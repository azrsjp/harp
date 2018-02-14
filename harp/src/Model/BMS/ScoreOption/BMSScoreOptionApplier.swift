import Foundation

final class BMSScoreOptionApplier {
  static func apply(scoreData: inout BMSScoreData, type: ScoreOptionType) {
    switch type {
    case .random:
      BMSRandomOption.apply(scoreData: &scoreData, includeScratch: false)
    case .randomPlus:
      BMSRandomOption.apply(scoreData: &scoreData, includeScratch: true)
    case .superRandom:
      BMSSuperRandomOption.apply(scoreData: &scoreData, includeScratch: false)
    case .superRandomPlus:
      BMSSuperRandomOption.apply(scoreData: &scoreData, includeScratch: true)
    case .mirror:
      BMSMirrorOption.apply(scoreData: &scoreData, includeScratch: false)
    case .mirrorPlus:
      BMSMirrorOption.apply(scoreData: &scoreData, includeScratch: true)
    case .none:
      break
    }
  }
}
