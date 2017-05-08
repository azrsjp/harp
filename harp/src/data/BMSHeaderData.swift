import Foundation

struct BMSHeaderData {
  var player: Int = 1
  var rank: Int = 3
  var total: Int = 200
  var stageFile: String = ""
  var banner: String = ""
  var playLevel: Int = 3
  var difficulty: Int = 2
  var title: String = ""
  var subTitle: String = ""
  var artist: String = ""
  var subArtist: String = ""
  var genre: String = ""
  var bpm: Double = 130.0
  var wav = [Int: String]()
  var cBpm = [Int: Double]()
  var exBpm = [Int: Double]()
  var bmp = [Int: String]()
  var stop = [Int: Int]()
  var lnobj: Int?
}
