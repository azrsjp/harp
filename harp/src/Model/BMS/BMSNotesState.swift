import Foundation

final class BMSNotesState {
  
  private let originalNotes: [BMSBarNoteData]

  private var aliveNotes = [BMSBarNoteData]()
  private var deadNotes = [BMSBarNoteData: Judge]()
  private var longNoteStates = [BMSLongNoteState]()

  init(data: BMSData) {
    aliveNotes
      = data.score.notes
        .filter { $0.trait.type != .invisible }
        .sorted { $0.0.tick < $0.1.tick }
    
    originalNotes = aliveNotes
    longNoteStates = makeLongStates()
  }
  
  // MARK: - internal
  
  var all: [BMSBarNoteData] {
    return originalNotes
  }
  
  var alive: [BMSBarNoteData] {
    return aliveNotes
  }

  var dead: [BMSBarNoteData] {
    return deadNotes.map { $0.key }
  }
  
  func longNotesInRange(_ tickRange: ClosedRange<Int>) -> [BMSLongNoteState] {
    return
      longNoteStates.filter {
        ($0.start.tick <= tickRange.lowerBound && tickRange.upperBound <= $0.end.tick) ||
        (tickRange.lowerBound <= $0.start.tick && $0.start.tick <= tickRange.upperBound) ||
        (tickRange.lowerBound <= $0.end.tick && $0.end.tick <= tickRange.upperBound)
    }
  }
  
  func judgeOf(note: BMSBarNoteData) -> Judge {
    guard let judge = deadNotes[note] else {
      return .notYet
    }
    
    return judge
  }
  
  func markLongStartNoteActive(_ note: BMSBarNoteData) {
    guard note.trait.type == .longStart else {
      return
    }
  
    if let index = longNoteStates.index(where: { $0.start == note }) {
      longNoteStates[index].isActive = true
    }
  }

  @discardableResult
  func markNoteAsDead(_ note: BMSBarNoteData, judge: Judge) -> Bool {
    guard judge != .positivePoor else {
      return false
    }
    guard let index = aliveNotes.index(where: { $0 == note }) else {
      return false
    }
    
    let deadNote = aliveNotes.remove(at: index)
    
    // If note is aldready dead state(long note) end note is judged poor.
    let shouldRecordJudge = getLongNoteState(by: note)?.isActive ?? true
    deadNotes[deadNote] = shouldRecordJudge ? judge : .negativePoor

    return shouldRecordJudge
  }

  @discardableResult
  func breakLongNoteStateIfNeeded(side: SideType, lane: LaneType, tick: Int) -> Bool {
    let laneHash = BMSNoteTraitData.laneHash(lane: lane, side: side)

    guard let index = longNoteStates
      .index(where: { $0.start.trait.laneHash == laneHash && $0.start.tick <= tick && tick <= $0.end.tick }) else {
      return false
    }

    let breakSuccess = longNoteStates[index].isActive

    longNoteStates[index].isActive = false

    return breakSuccess
  }
  
  // MARK: - private

  private func getLongNoteState(by note: BMSBarNoteData) -> BMSLongNoteState? {
    guard note.trait.type == .longEnd else {
      return nil
    }
    
    return longNoteStates.first { $0.end == note }
  }

  private func makeLongStates() -> [BMSLongNoteState] {
    let makeLongStartEndPair: (BMSBarNoteData) -> (BMSBarNoteData, BMSBarNoteData)? = { start in
      guard start.trait.type == .longStart else {
        return nil
      }
      guard let end
        = self.originalNotes.first(where: { $0.tick > start.tick && $0.trait.type == .longEnd }) else {
        return nil
      }

      return (start, end)
    }

    return originalNotes
      .filter { $0.trait.type == .longStart }
      .flatMap { makeLongStartEndPair($0) }
      .map { BMSLongNoteState(start: $0.0, end: $0.1, isActive: false) }
  }
}
