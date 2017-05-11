import Foundation

struct BMSChannelData {
  var startTick: Int = 0
  var barTickCount: Int = 0
  var barScale: Double = 1.0

  var playWav = [String]()
  var changeBpm: String?
  var changeBaseLayer: String?
  var changePoorLayer: String?
  var changeExBpm: String?
  var stopPlay: String?
  var notes = [BMSNoteTraitData: String]()
}
