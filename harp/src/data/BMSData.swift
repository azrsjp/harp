import Foundation

class BMSData {
  var header = BMSHeaderData()
  var channel = [BMSChannelData]()
  var bars = [BMSBarData]()

  var barLength: Int {
    return bars.count
  }

  func bar(atTick: Int) -> BMSBarData? {
    return bars.first {
      $0.startTick...($0.barTickCount + $0.startTick) ~= atTick
    }
  }
}
