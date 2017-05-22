import Foundation
import RxSwift

class PlayModel: Model {
  private let timer = TimerThread()
  private let disposeBag = DisposeBag()

  private var soundPlayer: SoundPlayer<Int>!
  private var bmsData: BMSData!
  private var sound: BMSSound!
  private var tick: BMSTick!
  private var judge: BMSJudge!
  private var coord: BMSNoteCoordinate!
  private var notes: BMSNotesState!

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

        self_.notes = BMSNotesState(data: self_.bmsData)
        self_.sound = BMSSound(data: self_.bmsData)
        self_.tick = BMSTick(data: self_.bmsData)
        self_.judge = BMSJudge(notes: self_.notes, tick: self_.tick)
        self_.coord = BMSNoteCoordinate(data: self_.bmsData, notes: self_.notes)
        self_.sound.updateKeyAssignAt(tick: 0)

        self_.isInitialized = true

        self_.startBMSPlayer()
      }).addDisposableTo(disposeBag)
  }

  func judge(event: GameEvent) {
    guard isInitialized else { return }

    judge.judge(event: event, elapsed: timer.elapsedSec)
  }

  func playKeySound(side: SideType, lane: LaneType) {
    guard isInitialized,
      let key = sound.keySoundKeyToPlay(side: side, lane: lane) else {
      return
    }

    soundPlayer?.play(forKey: key)
  }

  func currentCoordData() -> BMSCoordData? {
    guard isInitialized else { return nil }

    let currentTick = tick.tickAt(elapsedSec: timer.elapsedSec)

    return BMSCoordData(judge: judge.getLastJudge().rawValue,
                        combo: judge.getCombo(),
                        notes: coord.getNotesInLaneAt(tick: currentTick),
                        longNotes: coord.getLongNotesInLaneAt(tick: currentTick),
                        barLines: coord.getBarLinesInLaneAt(tick: currentTick))
  }

  // MARK: - private

  private func startBMSPlayer() {
    guard isInitialized else { return }

    timer.start {[weak self] in
      self?.update(elapsedSec: $0)
    }
  }

  private func update(elapsedSec: Double) {
    guard isInitialized, !Thread.isMainThread else {
      return
    }

    let currentTick = tick.tickAt(elapsedSec: elapsedSec)

    judge.judgeMissedNotesAt(elapsed: elapsedSec)

    let lookAheadTick = tick.tickAt(elapsedSec: elapsedSec + 1.0) - currentTick
    let lookBehindTick = currentTick - tick.tickAt(elapsedSec: elapsedSec - Config.BMS.badRange)
    sound.updateKeyAssignAt(tick: currentTick,
                            lookAheadTickCount: lookAheadTick,
                            lookBehindTickCount: lookBehindTick)

    sound
      .soundKeysToPlayAt(tick: currentTick)
      .forEach { [weak self] key in
        self?.soundPlayer?.play(forKey: key)
    }
  }
}
