import Foundation

struct BMSChannelData {
  var playWav = [String]()
  var changeScale: Double?
  var changeBpm: String?
  var changeBaseLayer: String?
  var changePoorLayer: String?
  var changeExBpm: String?
  var stopPlay: String?
  var notes = [BMSNoteTraitData: String]()
}
