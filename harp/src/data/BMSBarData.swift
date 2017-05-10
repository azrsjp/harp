import Foundation

struct BMSBarData {
  var startTick: Int = 0
  var barTickCount: Int = 0
  var barScale: Double = 1.0

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

struct BMSBarNoteData: BMSTimeSeries {
  var tick: Int = 0
  var key: Int = 0
  var trait: BMSNoteTraitData
}
