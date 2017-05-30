import Foundation
import RxSwift

final class BMSJudge {
  private let lock = NSLock()
  private let notes: BMSNotesState
  private let tick: BMSTick
  private let normalRange: BMSJudgeableRange
  private let longEndRange: BMSJudgeableRange
  private var lastJudge = Judge.notYet
  private var combo = 0

  private let subject = PublishSubject<JudgeData>()
  var observable: Observable<JudgeData> {
    return subject.asObservable()
  }

  init(notes: BMSNotesState, tick: BMSTick) {
    self.tick = tick
    self.notes = notes
    
    // JudgeRange is 2way, normal and longStart, or longEnd note
    self.normalRange = BMSJudgeableRange(pGreatRange: Config.BMS.pGreatRange,
                                         greatRange: Config.BMS.greatRange,
                                         goodRange: Config.BMS.goodRange,
                                         badRange: Config.BMS.badRange,
                                         poorRange: Config.BMS.badRange)

    let additionaRange = 0.08
    self.longEndRange = BMSJudgeableRange(pGreatRange: Config.BMS.pGreatRange + additionaRange,
                                         greatRange: Config.BMS.greatRange + additionaRange,
                                         goodRange: Config.BMS.goodRange + additionaRange,
                                         badRange: Config.BMS.badRange + additionaRange,
                                         poorRange: Config.BMS.badRange)
  }

  // MARK: - internal

  func judge(event: GameEvent, elapsed: Double) {
    guard let (lane, side) = event.sideAndLane else {
      return
    }

    let judgeResult
      = event.isKeyDownEvent ?
        judgeOnKeyDown(lane: lane, side: side, elapsed: elapsed) :
        judgeOnKeyUp(lane: lane, side: side, elapsed: elapsed)

    if let result = judgeResult {
      subject.onNext(JudgeData(judge: result, combo: combo, side: side))
    }
  }

  func judgeMissedNotesAt(elapsed: Double) {
    let missedNotes = notes.alive.filter {
      ($0.trait.type != .longEnd && normalRange.isInMissRange(elpased: elapsed, justTiming: tick.elapsedAt(tick: $0.tick))) ||
      ($0.trait.type == .longEnd && longEndRange.isInMissRange(elpased: elapsed, justTiming: tick.elapsedAt(tick: $0.tick)))
    }

    // On coming inActive(already dead) long note end judges, continue combo.
    var shouldBreakCombo = false

    missedNotes.forEach {
      let judgeSuccess = notes.markNoteAsDead($0, judge: .negativePoor)

      shouldBreakCombo = judgeSuccess || shouldBreakCombo
    }

    if shouldBreakCombo {
      updateComboAndCurrentJudge(judge: .negativePoor)
      subject.onNext(JudgeData(judge: .negativePoor, combo: combo, side: .player1))
    }
  }

  func getLastJudge() -> Judge {
    return lastJudge
  }

  func getCombo() -> Int {
    return combo
  }

  func getJudgeOf(note: BMSBarNoteData) -> Judge {
    return notes.judgeOf(note: note)
  }

  // MARK: - private

  private func findNoteToJudge(lane: LaneType, side: SideType,
                               elapsed: Double, range: BMSJudgeableRange) -> BMSBarNoteData? {
    let laneHash = BMSNoteTraitData.laneHash(lane: lane, side: side)

    guard let targetNote = notes.alive.first(where: {
        $0.trait.laneHash == laneHash &&
        range.isInJudgeableRange(elpased: elapsed, justTiming: tick.elapsedAt(tick: $0.tick)) }) else {
        return nil
    }

    return targetNote
  }
  
  private func judgeOnKeyDown(lane: LaneType, side: SideType, elapsed: Double) -> Judge? {
    guard let noteToJudge = findNoteToJudge(lane: lane, side: side, elapsed: elapsed, range: normalRange) else {
      return nil
    }
    
    let judgeResult = normalRange.getJudged(elapsed: elapsed, justTiming: tick.elapsedAt(tick: noteToJudge.tick))
    
    notes.markNoteAsDead(noteToJudge, judge: judgeResult)
    notes.markLongStartNoteActive(noteToJudge)
    updateComboAndCurrentJudge(judge: judgeResult)

    return judgeResult
  }
  
  private func judgeOnKeyUp(lane: LaneType, side: SideType, elapsed: Double) -> Judge? {
    guard let noteToJudge = findNoteToJudge(lane: lane, side: side, elapsed: elapsed, range: longEndRange) else {
      
      // If long note is active in the lane, judge long end note as poor by early key release.
      if notes.breakLongNoteStateIfNeeded(side: side, lane: lane, tick: tick.tickAt(elapsedSec: elapsed)) {
        updateComboAndCurrentJudge(judge: .negativePoor)
      }
      return .negativePoor
    }
    
    guard noteToJudge.trait.type == .longEnd else {
      return nil
    }
    
    var judgeResult = longEndRange.getJudged(elapsed: elapsed, justTiming: tick.elapsedAt(tick: noteToJudge.tick))
    
    // overwrite judge to break combo
    if judgeResult == .positivePoor {
      judgeResult = .negativePoor
    }
    
    // Indicate as broken long note (set long note bar inactive)
    if [.bad, .negativePoor].contains(judgeResult) {
      notes.breakLongNoteStateIfNeeded(side: side, lane: lane, tick: tick.tickAt(elapsedSec: elapsed))
    }
    
    updateComboAndCurrentJudge(judge: judgeResult)
    notes.markNoteAsDead(noteToJudge, judge: judgeResult)
    
    return judgeResult
  }

  private func updateComboAndCurrentJudge(judge: Judge) {
    if [.perfectGreat, .great, .good].contains(judge) {
      combo += 1
    } else if [.positivePoor].contains(judge) {
      // do nothing for combo
    } else {
      combo = 0
    }

    lastJudge = judge
  }
}
