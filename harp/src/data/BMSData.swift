import Foundation

class BMSData {
  var header = BMSHeaderData()
  var channel = [BMSChannelData]()
  var score = BMSScoreData()

  var barLength: Int {
    return channel.count
  }
}
