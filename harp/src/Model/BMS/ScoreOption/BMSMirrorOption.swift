import Foundation

final class BMSMirrorOption {
  static func apply(scoreData: inout BMSScoreData, includeScratch: Bool) {
    let laneMap = includeScratch ? mirrorLaneMapPlus() : mirrorLaneMap()
    
    scoreData.notes
      = scoreData.notes.map { $0.laneChanged(lane: laneMap[$0.trait.lane] ?? $0.trait.lane) }
  }
  
  static private func mirrorLaneMap() -> [LaneType: LaneType] {
    return [.key1: .key7,
            .key2: .key6,
            .key3: .key5,
            .key4: .key4,
            .key5: .key3,
            .key6: .key2,
            .key7: .key1]
  }
  
  static private func mirrorLaneMapPlus() -> [LaneType: LaneType] {
    return [.key1: .scratch,
            .key2: .key7,
            .key3: .key6,
            .key4: .key5,
            .key5: .key4,
            .key6: .key3,
            .key7: .key2,
            .scratch: .key1]
  }
}
