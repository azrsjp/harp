import Foundation

struct BMSScoreData {
  // Refer to BMSHeaderData.wav[XX]
  var notes = [BMSBarNoteData]()

  // Refer to BMSHeaderData.wav[XX]
  var playWav = [BMSBarEventData]()

  // Hold concrete value in itself
  var changeExBpm = [BMSBarBPMEventData]()

  // Refer to BMSHeaderData.bmp[XX]
  var changeBaseLayer = [BMSBarEventData]()

  // Refer to BMSHeaderData.bmp[XX]
  var changePoorLayer = [BMSBarEventData]()

  // Refer to BMSHeaderData.stop[XX]
  var stopPlay = [BMSBarEventData]()
}

protocol BMSTimeSeries {
  var tick: Int { get set }
}

struct BMSBarEventData: BMSTimeSeries {
  var tick: Int = 0
  var key: Int = 0
}

struct BMSBarBPMEventData: BMSTimeSeries {
  var tick: Int = 0
  var value: Double = 0
}

struct BMSBarNoteData: BMSTimeSeries, Equatable, Hashable {
  var tick: Int = 0
  var key: Int = 0
  var trait: BMSNoteTraitData
  
  var hashValue: Int {
    return (String(tick) + "/" + String(key) + "/" + String(trait.hashValue)).hashValue
  }
  
  static func == (lhs: BMSBarNoteData,
                  rhs: BMSBarNoteData) -> Bool {
    return
      lhs.tick == rhs.tick &&
      lhs.key == rhs.key &&
      lhs.trait == rhs.trait
  }
  
  func laneChanged(lane: LaneType) -> BMSBarNoteData {
    var copy = self
    copy.trait.lane = lane

    return copy
  }
}
