import Foundation
import RxSwift

class PlayModel: Model {
  private let thread = ElapsedBasedThread()
  private let disposeBag = DisposeBag()

  private var soundPlayer: SoundPlayer<Int>?
  private var bmsData: BMSData?
  private var tick: BMSTick?
  private let coordinate = BMSNoteCoordinate()
  private var sound: BMSSound?

  deinit {
    thread.cancel()
  }

  // MARK: - internal

  func loadBMSFileAndIntialize(fullFilePath: String) {
    guard
      let lines = String(unknownEncodingContentsOfFile: fullFilePath),
      let playerFactory = SoundPlayerFactory.shared,
      let dirPath = fullFilePath.getFileDirPathIfAvailable() else {
        return
    }

    BMSParser.parse(contentsOfBMS: lines)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
      .do(onNext: { [weak self] in self?.bmsData = $0 })
      .map { $0.header.wav.mapValue { dirPath + "/" + $0 } }
      .flatMap { playerFactory.makePlayer(keyAndFileFullPath: $0) }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] player in
        guard let self_ = self else {
          return
        }

        Logger.info("Resources is loaded")

        self_.soundPlayer = player
        self_.tick = BMSTick(data: self_.bmsData!)
        self_.sound = BMSSound(data: self_.bmsData!)
        self_.sound!.updateKeyAssignAt(tick: 0)

        self_.startBMSPlayer()
      }).addDisposableTo(disposeBag)
  }

  func playKeySound(side: SideType, lane: LaneType) {
    guard let key = sound?.keySoundKeyToPlay(side: side, lane: lane) else {
      return
    }

    soundPlayer?.play(forKey: key)
  }

  // MARK: - private

  private func startBMSPlayer() {

    thread.start { [weak self] elapsed in
      guard let self_ = self else {
        return
      }

      self_.update(elapsed)
    }
  }

  private func update(_ elapsed: Double) {
    let currentTick = tick!.tickAt(elapsedSec: elapsed)
    
    sound!.updateKeyAssignAt(tick: currentTick, lookAheadTickCount: 1000)
    
    sound!
      .soundKeysToPlayAt(tick: currentTick)
      .forEach { [weak self] key in
        self?.soundPlayer?.play(forKey: key)
    }
  }
}
