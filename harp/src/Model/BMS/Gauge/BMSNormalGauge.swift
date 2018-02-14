import Foundation

class BMSNormalGauge: BMSGauge {
  private(set) var total: Double
  private(set) var noteNum: Double
  private(set) var value: Double
  
  // value to show on ui
  var revisedValue: Int {
    get {
      if value <= 2.0 {
        return 2
      }
      
      return (Int(value) / 2) * 2
    }
  }

  required init(total: Int, noteNum: Int) {
    self.total = Double(total)
    self.noteNum = Double(noteNum)
    self.value = 20.0
  }

  func applyJudge(judge: Judge) -> Int {
    switch judge {
    case .perfectGreat:
      value = value + total / noteNum
    case .great:
      value = value + total / noteNum
    case .good:
      value = value + (total / noteNum) * 0.5
    case .bad:
      value = value + (-4.0)
    case .positivePoor:
      value = value + (-2.0)
    case .negativePoor:
      value = value + (-6.0)
    default: break
    }

    value = max(0.0, min(100.0, value))
    
    return revisedValue
  }
}
