import Foundation

class BMSData {
  var header = BMSHeaderData()
  var channel = [BMSChannelData]()
  var bars = [BMSBarData]()

  var barLength: Int {
    return bars.count
  }
}
