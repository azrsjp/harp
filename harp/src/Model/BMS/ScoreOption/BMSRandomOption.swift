import Foundation

final class BMSRandomOption {
  static func apply(scoreData: inout BMSScoreData, includeScratch: Bool) {
    let laneMap = includeScratch ? randomLaneMapPlus() : randomLaneMap()
    
    scoreData.notes
      = scoreData.notes.map { $0.laneChanged(lane: laneMap[$0.trait.lane] ?? $0.trait.lane) }
  }
  
  static private func randomLaneMap() -> [LaneType: LaneType] {
    let order: [LaneType] = [.key1, .key2, .key3, .key4, .key5, .key6, .key7].shuffled()
    
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
}
