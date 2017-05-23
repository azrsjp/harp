import Foundation
import RxSwift

class PlayModel: Model {
  private let timer = TimerThread()
  private let disposeBag = DisposeBag()

  private var soundPlayer: SoundPlayer<Int>!
  private var bmsData: BMSData!
  private var model: BMSModelSystem!

  private var isInitialized = false

  deinit {
    timer.cancel()
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
      .do(onNext: {[weak self] in self?.model = BMSModelSystem(data: $0) })
      .map { $0.header.wav.mapValue { dirPath + "/" + $0 } }
      .flatMap { playerFactory.makePlayer(keyAndFileFullPath: $0) }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] player in
        guard let self_ = self else {
          return
        }

        Logger.info("Resources is loaded")

        self_.soundPlayer = player
        self_.isInitialized = true

        self_.startBMSPlayer()
      }).addDisposableTo(disposeBag)
  }

  func judge(event: GameEvent) {
    guard isInitialized else { return }

    model.judge.judge(event: event, elapsed: timer.elapsedSec)
  }

  func playKeySound(side: SideType, lane: LaneType) {
    guard isInitialized,
      let key = model.sound.keySoundKeyToPlay(side: side, lane: lane) else {
      return
    }

    soundPlayer?.play(forKey: key)
  }

  func currentCoordData() -> BMSCoordData? {
    guard isInitialized else { return nil }

    let currentTick = model.tick.tickAt(elapsedSec: timer.elapsedSec)

    return BMSCoordData(judge: model.judge.getLastJudge().rawValue,
                        combo: model.judge.getCombo(),
                        notes: model.coord.getNotesInLaneAt(tick: currentTick),
                        longNotes: model.coord.getLongNotesInLaneAt(tick: currentTick),
                        barLines: model.coord.getBarLinesInLaneAt(tick: currentTick))
  }

  // MARK: - private

  private func startBMSPlayer() {
    guard isInitialized else { return }

    model.sound.updateKeyAssignAt(tick: 0)
    
    timer.start {[weak self] in
      self?.update(elapsedSec: $0)
    }
  }

  private func update(elapsedSec: Double) {
    guard isInitialized, !Thread.isMainThread else {
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
