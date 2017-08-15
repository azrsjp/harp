import Foundation

final class BMSSuperRandomOption {
  static func apply(scoreData: inout BMSScoreData, containsScratch: Bool) {
    var shuffled = [BMSBarNoteData]()
    
    // Firstly, shuffle only long notes
    makeLongNotesPairs(from: scoreData.notes)
      .sorted { $0.0.0.tick < $0.1.0.tick }
      .forEach {
        while true {
          let laneMap = containsScratch ? randomLaneMapPlus() : randomLaneMap()
          let newLongStart = $0.0.laneChanged(lane: laneMap[$0.0.trait.lane] ?? $0.0.trait.lane)
          let newLongEnd = $0.1.laneChanged(lane: laneMap[$0.0.trait.lane] ?? $0.0.trait.lane)

          if canPlaceNote(toPlace: newLongStart, in: shuffled) {
            shuffled.append(newLongStart)
            shuffled.append(newLongEnd)
            break
          }
        }
    }

    // Then, shuffle normal notes
    scoreData.notes
      .filter { $0.trait.type != .longStart && $0.trait.type != .longEnd }
      .forEach {
        while true {
          let laneMap = containsScratch ? randomLaneMapPlus() : randomLaneMap()
          let newNote = $0.laneChanged(lane: laneMap[$0.trait.lane] ?? $0.trait.lane)
          
          if canPlaceNote(toPlace: newNote, in: shuffled) {
            shuffled.append(newNote)
            break
          }
        }
    }
    
    // apply
    scoreData.notes = shuffled.sorted { $0.0.tick < $0.1.tick }
  }
  
  static private func randomLaneMap() -> [LaneType: LaneType] {
    var order: [LaneType] = [.key1, .key2, .key3, .key4, .key5, .key6, .key7].shuffled()
    
    return [.key1: order[0],
            .key2: order[1],
            .key3: order[2],
            .key4: order[3],
            .key5: order[4],
            .key6: order[5],
            .key7: order[6]]
  }
  
  static private func randomLaneMapPlus() -> [LaneType: LaneType] {
    let order: [LaneType] = [.key1, .key2, .key3, .key4, .key5, .key6, .key7, .scratch].shuffled()
    
    return [.key1: order[0],
            .key2: order[1],
            .key3: order[2],
            .key4: order[3],
            .key5: order[4],
            .key6: order[5],
            .key7: order[6],
            .scratch: order[7]]
  }
  
  static private func canPlaceNote(toPlace: BMSBarNoteData,
                                   in notes: [BMSBarNoteData]) -> Bool {
    let shouldValidateNotes
      = notes.filter { $0.trait.lane == toPlace.trait.lane && $0.trait.side == toPlace.trait.side }

    let isInLongNoteRange
      = makeLongNotesPairs(from: shouldValidateNotes)
        .contains { $0.0.tick <= toPlace.tick && toPlace.tick <= $0.1.tick }
    
    let isAtDublicatedTick
      = shouldValidateNotes.contains { $0.tick == toPlace.tick }

    return !isInLongNoteRange && !isAtDublicatedTick
  }
  
  static private func makeLongNotesPairs(from: [BMSBarNoteData]) -> [(BMSBarNoteData, BMSBarNoteData)] {
    var longNotePairs = [(BMSBarNoteData, BMSBarNoteData)]()

    LaneType.values.forEach { lane in
      let longStarts = from.filter { lane == $0.trait.lane && $0.trait.type == .longStart }
      let longEnds = from.filter { lane == $0.trait.lane && $0.trait.type == .longEnd }
      let longNotePairsInLane = zip(longStarts, longEnds).map { ($0, $1) }
      
      longNotePairs.append(contentsOf: longNotePairsInLane)
    }
    
    return longNotePairs
  }
}
