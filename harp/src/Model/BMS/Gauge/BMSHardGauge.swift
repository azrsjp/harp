import Foundation

class BMSHardGauge: BMSGauge {
  private(set) var total: Double
  private(set) var noteNum: Double
  private(set) var value: Double
  
  // value to show on ui
  var revisedValue: Int {
    get {
      if value <= 0.0 {
        return 0
      }
      if value < 2.0 {
        return 2
      }
      
      return (Int(value) / 2) * 2
    }
  }
  
  required init(total: Int, noteNum: Int) {
    self.total = Double(total)
    self.noteNum = Double(noteNum)
    self.value = 100.0
  }
  
  func applyJudge(judge: Judge) -> Int {
    switch judge {
    case .perfectGreat:
      value = value + 0.16
    case .great:
      value = value + 0.16
    case .good:
      break
    case .bad:
      value = value + (-5.0)
    case .positivePoor:
      value = value + (-5.0)
    case .negativePoor:
      value = value + (-9.0)
    default: break
    }
    
    value = max(0.0, min(100.0, value))
    
    return revisedValue
  }
}
