import Foundation

fileprivate struct BMSSoundData {
  var key: Int
  var tick: Int
}

fileprivate struct BMSKeySoundData {
  var key: Int
  var tick: Int
  var trait: BMSNoteTraitData
}

fileprivate struct BMSKeyAssignedKey: Hashable {

  var side: SideType
  var lane: LaneType
  
  var hashValue: Int {
    return side.rawValue * 10 + lane.rawValue
  }
  
  static func == (lhs: BMSKeyAssignedKey, rhs: BMSKeyAssignedKey) -> Bool {
    return lhs.lane == rhs.lane && lhs.side == rhs.side
  }
}

final class BMSSound {

  private var playSoundList = [BMSSoundData]()
  private var keySoundList = [BMSKeySoundData]()
  private var keyAssignedSound = [BMSKeyAssignedKey:Int]()
  
  // MARK: - internal
  
  init(data: BMSData) {

    playSoundList
      = data.score.playWav
        .map { BMSSoundData(key: $0.key, tick: $0.tick) }
        .sorted { $0.0.tick < $0.1.tick }

    keySoundList
      = data.score.notes
        .map { BMSKeySoundData(key: $0.key, tick: $0.tick, trait: $0.trait) }
        .sorted { $0.0.tick < $0.1.tick }
  }
  
  func soundKeysToPlayAt(tick: Int) -> [Int] {
    // Care processing falling
    let lookBehindTick = 10000
    let lookRange = (tick-lookBehindTick)...tick

    var result = [Int]()

    let soundCount = playSoundList.count

    for i in 0..<soundCount {
      if lookRange ~= playSoundList[i].tick {
        result.append(playSoundList[i].key)
      } else {
        // Remove sounds has alredy plyaed
        playSoundList.removeSubrange(0..<i)
        break
      }
    }

    return result
  }
  
  func keySoundKeyToPlay(side: SideType, lane: LaneType) -> Int? {
    return keyAssignedSound[BMSKeyAssignedKey(side: side, lane: lane)]
  }

  func updateKeyAssignAt(tick: Int, lookAheadTickCount: Int? = nil) {
    let lookAhead = lookAheadTickCount ?? NSIntegerMax
    let lookRange = tick...(tick + lookAhead)

    let keySoundCount = keySoundList.count

    for i in 0..<keySoundCount {
      if lookRange ~= keySoundList[i].tick {
        let trait = keySoundList[i].trait
        let soundKey = keySoundList[i].key
        let assignedKey = BMSKeyAssignedKey(side: trait.side, lane: trait.lane)

        keyAssignedSound[assignedKey] = soundKey
      } else {
        // Remove sounds has alredy plyaed
        keySoundList.removeSubrange(0..<i)
        break
      }
    }
  }
}
