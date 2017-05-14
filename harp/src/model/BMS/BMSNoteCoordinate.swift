import Foundation

final class BMSNoteCoordinate {

  private var hiSpeed: Double
  private var basePixelPerTick: Double
  
  // MARK: - internal

  init() {
    hiSpeed = 1.0
    basePixelPerTick = Config.BMS.defaultBarHeight / Double(Config.BMS.baseBarTick)
  }

  func setHiSpeed(_ hiSpeed: Double) {
    self.hiSpeed = hiSpeed
  }
  
  func coordYOfNote(tick: Int) -> Double {
    let y = basePixelPerTick * hiSpeed * Double(tick)

    return y
  }
  
  func tickRangeInLane(startTick: Int) -> ClosedRange<Int> {
    let endTick = Int(Config.BMS.defaultLaneHeight / (basePixelPerTick * hiSpeed))
    
    return startTick...(startTick + endTick)
  }
}
