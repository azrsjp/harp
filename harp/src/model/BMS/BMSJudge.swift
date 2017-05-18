import Foundation

fileprivate let eventToLane: [GameEvent: LaneType]
  = [
    GameEvent.noteOn1: LaneType.key1,
    GameEvent.noteOff1: LaneType.key1,
    GameEvent.noteOn2: LaneType.key2,
    GameEvent.noteOff2: LaneType.key2,
    GameEvent.noteOn3: LaneType.key3,
    GameEvent.noteOff3: LaneType.key3,
    GameEvent.noteOn4: LaneType.key4,
    GameEvent.noteOff4: LaneType.key4,
    GameEvent.noteOn5: LaneType.key5,
    GameEvent.noteOff5: LaneType.key5,
    GameEvent.noteOn6: LaneType.key6,
    GameEvent.noteOff6: LaneType.key6,
    GameEvent.noteOn7: LaneType.key7,
    GameEvent.noteOff7: LaneType.key7,
    GameEvent.scrachLeft: LaneType.scratch,
    GameEvent.scrachRight: LaneType.scratch,
    GameEvent.scrachEnd: LaneType.scratch
  ]

final class BMSJudge {

  static private let comobChainer: [Judge] = [.perfectGreat, .great, .good]
  private let lock = NSLock()

  private let tick: BMSTick
  private var notYetJudgedNotes = [BMSBarNoteData]()
  private var judgedData = [BMSBarNoteData: Judge]()
  private var inLongNoteState = [BMSNoteTraitData]()

  private var lastJudge = Judge.notYet
  private var combo = 0

  init(data: BMSData) {
    tick = BMSTick(data: data)

    notYetJudgedNotes = data.score.notes
  }

  // MARK: - internal

  func judge(event: GameEvent, elapsed: Double) {
    lock.lock()
    defer { lock.unlock() }
    
    guard let lane = eventToLane[event] else {
      return
    }

    guard let judgeTargetIndex = getJudgeTargetNoteIndex(lane: lane, elapsed: elapsed) else {

      // If long note is active in the lane, key is released early, so judge long end note as poor.
      if let startLongNoteTrait = inLongNoteState.first(where: { $0.lane == lane }) {
        breakLongNoteByEarlyRelaseKey(trait: startLongNoteTrait)
      }

      return
    }

    let judgeTargetNote = notYetJudgedNotes.remove(at: judgeTargetIndex)
    let judged = getJudged(elapsed: elapsed, justTiming: tick.elapsedAt(tick: judgeTargetNote.tick))

    updateComboAndCurrentJudge(judge: judged)

    switch event {
    case .noteOn1: fallthrough
    case .noteOn2: fallthrough
    case .noteOn3: fallthrough
    case .noteOn4: fallthrough
    case .noteOn5: fallthrough
    case .noteOn6: fallthrough
    case .noteOn7: fallthrough
    case .scrachLeft: fallthrough
    case .scrachRight:
      judgedData[judgeTargetNote] = judged
      startLongNoteIfNeeded(note: judgeTargetNote)
    case .noteOff1: fallthrough
    case .noteOff2: fallthrough
    case .noteOff3: fallthrough
    case .noteOff4: fallthrough
    case .noteOff5: fallthrough
    case .noteOff6: fallthrough
    case .noteOff7:
      judgedData[judgeTargetNote] = judged
      breakLongNoteIfNeeded(note: judgeTargetNote)
    default: break
    }
  }

  func judgeMissedNotesAt(elapsed: Double) {
    lock.lock()
    defer { lock.unlock() }

    let missedNotes
      = notYetJudgedNotes.filter { isInMissRange(elpased: elapsed,
                                                 justTiming: tick.elapsedAt(tick: $0.tick)) }

    guard missedNotes.count > 0 else {
      return
    }

    missedNotes.forEach {
      judgedData[$0] = .negativePoor
      breakLongNoteIfNeeded(note: $0)
    }

    updateComboAndCurrentJudge(judge: .negativePoor)
  }

  func getLastJudge() -> Judge {
    return lastJudge
  }

  func getCombo() -> Int {
    return combo
  }

  func getJudgeOf(note: BMSBarNoteData) -> Judge {
    guard let judge = judgedData[note] else {
      return .notYet
    }

    return judge
  }

  // MARK: - private

  private func getJudgeTargetNoteIndex(lane: LaneType, elapsed: Double) -> Array<BMSBarNoteData>.Index? {
    guard let judgeTargetIndex
      = notYetJudgedNotes.index(where: {
        $0.trait.lane == lane &&
        $0.trait.type != .invisible &&
        isInJudgeableRange(elpased: elapsed, justTiming: tick.elapsedAt(tick: $0.tick)) }) else {
        return nil
    }

    return judgeTargetIndex
  }

  private func isInJudgeableRange(elpased: Double, justTiming: Double) -> Bool {
    let isOverJudgeLine = elpased - justTiming > 0.0

    return isOverJudgeLine ?
    isInBadRange(elpased: elpased, justTiming: justTiming):
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

  private func updateComboAndCurrentJudge(judge: Judge) {
    if BMSJudge.comobChainer.contains(judge) {
      combo += 1
    } else {
      combo = 0
    }

    lastJudge = judge
  }

  private func startLongNoteIfNeeded(note: BMSBarNoteData) {
    guard note.trait.type == .longStart else {
      return
    }

    if !inLongNoteState.contains(where: { $0 == note.trait }) {
      inLongNoteState.append(note.trait)
    }
  }

  private func breakLongNoteIfNeeded(note: BMSBarNoteData) {
    guard note.trait.type == .longEnd else {
      return
    }

    let longNoteStartTrait
      = BMSNoteTraitData(side: note.trait.side, lane: note.trait.lane, type: .longStart)

    if let index = inLongNoteState.index(where: { $0 == longNoteStartTrait }) {
      inLongNoteState.remove(at: index)
    }
  }

  private func breakLongNoteByEarlyRelaseKey(trait: BMSNoteTraitData) {
    guard trait.type == .longStart else {
      return
    }

    if let index = inLongNoteState.index(where: { $0 == trait }) {
      inLongNoteState.remove(at: index)
    }

    let longNoteEndTrait
      = BMSNoteTraitData(side: trait.side, lane: trait.lane, type: .longEnd)

    guard let nextLongNoteEndIndex
      = notYetJudgedNotes.index(where: { $0.trait == longNoteEndTrait }) else {
        return
    }

    let nextLongNoteEnd = notYetJudgedNotes.remove(at: nextLongNoteEndIndex)
    judgedData[nextLongNoteEnd] = .negativePoor

    updateComboAndCurrentJudge(judge: .negativePoor)
  }
}
