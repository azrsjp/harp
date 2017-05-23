import Foundation

final class BMSJudge {
  private let lock = NSLock()
  private let notes: BMSNotesState
  private let tick: BMSTick
  private var lastJudge = Judge.notYet
  private var combo = 0

  init(notes: BMSNotesState, tick: BMSTick) {
    self.tick = tick
    self.notes = notes
  }

  // MARK: - internal

  func judge(event: GameEvent, elapsed: Double) {
    lock.lock()
    defer { lock.unlock() }

    guard let (lane, side) = event.sideAndLane else {
      return
    }

    guard let noteToJudge = findNoteToJudge(lane: lane, side: side, elapsed: elapsed) else {

      // If long note is active in the lane, judge long end note as poor by early key release.
      if !event.isKeyDownEvent,
        notes.breakLongNoteStateIfNeeded(side: side, lane: lane, tick: tick.tickAt(elapsedSec: elapsed)) {
        updateComboAndCurrentJudge(judge: .negativePoor)
      }

      return
    }

    guard event.isKeyDownEvent ||
      (!event.isKeyDownEvent && noteToJudge.trait.type == .longEnd) else {
      return
    }

    let judgeResult = getJudged(elapsed: elapsed, justTiming: tick.elapsedAt(tick: noteToJudge.tick))

    notes.markNoteAsDead(noteToJudge, judge: judgeResult)
    notes.markLongStartNoteActive(noteToJudge)
    updateComboAndCurrentJudge(judge: judgeResult)
  }

  func judgeMissedNotesAt(elapsed: Double) {
    lock.lock()
    defer { lock.unlock() }

    let missedNotes = notes.alive.prefix { isInMissRange(elpased: elapsed,
                                                         justTiming: tick.elapsedAt(tick: $0.tick)) }
    
    // If only inActive long note judges, continue combo.
    var shouldRecordJudged = false

    missedNotes.forEach {
      let judgeSuccess = notes.markNoteAsDead($0, judge: .negativePoor)

      shouldRecordJudged = judgeSuccess || shouldRecordJudged
    }

    if shouldRecordJudged {
      updateComboAndCurrentJudge(judge: .negativePoor)
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

  private func findNoteToJudge(lane: LaneType, side: SideType, elapsed: Double) -> BMSBarNoteData? {
    guard let targetNote = notes.alive.first(where: {
        $0.trait.lane == lane &&
        $0.trait.side == side &&
        isInJudgeableRange(elpased: elapsed, justTiming: tick.elapsedAt(tick: $0.tick)) }) else {
        return nil
    }

    return targetNote
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

  private func isInJudgeableRange(elpased: Double, justTiming: Double) -> Bool {
    let isOverJudgeLine = elpased - justTiming > 0.0

    return isOverJudgeLine ?
    isInBadRange(elpased: elpased, justTiming: justTiming) :
      isInPoorRange(elpased: elpased, justTiming: justTiming)
  }

  private func isInMissRange(elpased: Double, justTiming: Double) -> Bool {
    let diff = elpased - justTiming

    guard diff > 0.0 else {
      return false
    }

    return diff > Config.BMS.badRange
  }

  private func isInPerfectGreatRange(elpased: Double, justTiming: Double) -> Bool {
    return abs(elpased - justTiming) <= Config.BMS.pGreatRange
  }

  private func isInGreatRange(elpased: Double, justTiming: Double) -> Bool {
    return abs(elpased - justTiming) <= Config.BMS.greatRange
  }

  private func isInGoodRange(elpased: Double, justTiming: Double) -> Bool {
    return abs(elpased - justTiming) <= Config.BMS.goodRange
  }

  private func isInBadRange(elpased: Double, justTiming: Double) -> Bool {
    return abs(elpased - justTiming) <= Config.BMS.badRange
  }

  private func isInPoorRange(elpased: Double, justTiming: Double) -> Bool {
    return abs(elpased - justTiming) <= Config.BMS.poorRange
  }

  private func getJudged(elapsed: Double, justTiming: Double) -> Judge {
    switch true {
    case isInPerfectGreatRange(elpased: elapsed, justTiming: justTiming): return .perfectGreat
    case isInGreatRange(elpased: elapsed, justTiming: justTiming): return .great
    case isInGoodRange(elpased: elapsed, justTiming: justTiming): return .good
    case isInBadRange(elpased: elapsed, justTiming: justTiming): return .bad
    case isInPoorRange(elpased: elapsed, justTiming: justTiming): return .positivePoor
    default: break
    }

    return .negativePoor
  }
}
