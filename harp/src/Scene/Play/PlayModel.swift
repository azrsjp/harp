import Foundation
import RxSwift

class PlayModel: Model {
  private let timer = TimerThread()
  private let disposeBag = DisposeBag()

  private var soundPlayer: SoundPlayer<Int>!
  private let model: BMSModelSystem
  
  override init() {
    let options = GameOptionData()
    model = BMSModelSystem(gameOptions: options)

    super.init()
  }

  deinit {
    timer.cancel()
  }

  // MARK: - internal

  func loadBMSFileAndIntialize(fullFilePath: String, originSec: Double = 0.0) {
    guard
      !model.isReady,
      let lines = String(unknownEncodingContentsOfFile: fullFilePath),
      let playerFactory = SoundPlayerFactory.shared,
      let dirPath = fullFilePath.getFileDirPathIfAvailable() else {
        return
    }

    BMSParser.parse(contentsOfBMS: lines)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
      .do(onNext: {[weak self] in self?.model.prepareData(data: $0) })
      .map { $0.header.wav.mapValue { dirPath + "/" + $0 } }
      .flatMap { playerFactory.makePlayer(keyAndFileFullPath: $0) }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] player in
        guard let self_ = self else {
          return
        }

        Logger.info("Resources is loaded")
        
        self_.soundPlayer = player
        self_.startBMSPlayer(at: originSec)
      }).addDisposableTo(disposeBag)
  }
  
  func addCoverCount(_ value: Double) {
    model.addCoverCount(value)
  }
  
  func addLiftCount(_ value: Double) {
    model.addLiftCount(value)
  }
  
  func addHiSpeedCount(_ value: Double) {
    model.addHiSpeedCount(value)
  }

  func judge(event: GameEvent) {
    guard model.isReady else { return }

    model.judge.judge(event: event, elapsed: timer.elapsedSec)
  }

  func playKeySound(side: SideType, lane: LaneType) {
    guard model.isReady,
      let key = model.sound.keySoundKeyToPlay(side: side, lane: lane) else {
      return
    }

    soundPlayer?.play(forKey: key)
  }

  func currentCoordData() -> BMSCoordData {
    let currentTick = model.tick?.tickAt(elapsedSec: timer.elapsedSec) ?? 0

    return model.currentCoordData(tick: currentTick)
  }

  // MARK: - private

  private func startBMSPlayer(at: Double = 0.0) {
    guard model.isReady else { return }

    model.sound.updateKeyAssignAt(tick: 0)
    
    timer.start(origin: at) {[weak self] in
      self?.update(elapsedSec: $0)
    }
  }

  private func update(elapsedSec: Double) {
    guard model.isReady, !Thread.isMainThread else {
      return
    }

    let currentTick = model.tick.tickAt(elapsedSec: elapsedSec)

    model.judge.judgeMissedNotesAt(elapsed: elapsedSec)

    let lookAheadTick = model.tick.tickAt(elapsedSec: elapsedSec + 1.0) - currentTick
    let lookBehindTick = currentTick - model.tick.tickAt(elapsedSec: elapsedSec - Config.BMS.badRange)
    model.sound.updateKeyAssignAt(tick: currentTick,
                                  lookAheadTickCount: lookAheadTick,
                                  lookBehindTickCount: lookBehindTick)

    model.sound
      .soundKeysToPlayAt(tick: currentTick)
      .forEach { [weak self] key in
        self?.soundPlayer?.play(forKey: key)
    }
  }
}
