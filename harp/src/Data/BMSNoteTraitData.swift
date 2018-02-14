import Foundation

struct BMSNoteTraitData: Equatable, Hashable {
  var side: SideType
  var lane: LaneType
  var type: NoteType
  
  var hashValue: Int {
    return side.rawValue * type.rawValue + lane.rawValue
  }

  var laneHash: Int {
    return BMSNoteTraitData.laneHash(lane: lane, side: side)
  }

  static func laneHash(lane: LaneType, side: SideType) -> Int {
    return lane.hashValue * side.rawValue
  }

  static func == (lhs: BMSNoteTraitData,
                  rhs: BMSNoteTraitData) -> Bool {
    return
      lhs.side == rhs.side &&
      lhs.lane == rhs.lane &&
      lhs.type == rhs.type
  }
}
