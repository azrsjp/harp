import Foundation

final class BMSGaugeFactory {
  static func makeGauge(type: GaugeType, total: Int, noteNum: Int) -> BMSGauge {
    switch type {
    case .normal: return BMSNormalGauge(total: total, noteNum: noteNum)
    case .easy: return BMSEasyGauge(total: total, noteNum: noteNum)
    case .hard: return BMSHardGauge(total: total, noteNum: noteNum)
    case .exHard: return BMSExHardGauge(total: total, noteNum: noteNum)
    }
  }
}
