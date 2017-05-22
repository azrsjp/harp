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

final class BMSSound {

  private var playSoundList = [BMSSoundData]()
  private var keySoundList = [BMSKeySoundData]()
  private var keyAssignedSound = [Int: Int]()
  
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

    let inRangeSounds = Array(playSoundList.prefix(while: { lookRange ~= $0.tick })).map { $0.key }
    
    playSoundList = Array(playSoundList.drop(while: { $0.tick <= tick }))

    return inRangeSounds
  }
  
  func keySoundKeyToPlay(side: SideType, lane: LaneType) -> Int? {
    let laneHash = BMSNoteTraitData.laneHash(lane: lane, side: side)

    return keyAssignedSound[laneHash]
  }

  func updateKeyAssignAt(tick: Int, lookAheadTickCount: Int? = nil, lookBehindTickCount: Int? = nil) {
    let lookAhead = lookAheadTickCount ?? NSIntegerMax
    let lookBehind = lookBehindTickCount ?? 0
    let lookRange = (tick - lookBehind)...(tick + lookAhead)

    keySoundList = Array(keySoundList.drop(while: { $0.tick < (tick - lookBehind) }))

    let inRangeNotes = Array(keySoundList.prefix(while: { lookRange ~= $0.tick }))

    SideType.values.forEach { side in
      LaneType.values.forEach { lane in
        if let note = inRangeNotes.first(where: { $0.trait.lane == lane && $0.trait.side == side }) {
          let laneHash = BMSNoteTraitData.laneHash(lane: note.trait.lane, side: note.trait.side)

          keyAssignedSound[laneHash] = note.key
        }
      }
    }
  }
}
