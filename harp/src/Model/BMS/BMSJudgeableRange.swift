import Foundation

final class BMSJudgeableRange {
  
  private let pGreatRange: Double
  private let greatRange: Double
  private let goodRange: Double
  private let badRange: Double
  private let poorRange: Double
  
  init(pGreatRange: Double, greatRange: Double, goodRange: Double,
       badRange: Double, poorRange: Double) {
    self.pGreatRange = pGreatRange
    self.greatRange = greatRange
    self.goodRange = goodRange
    self.badRange = badRange
    self.poorRange = poorRange
  }
  
  func getJudged(elapsed: Double, justTiming: Double) -> Judge {
    switch true {
    case isInPerfectGreatRange(elpased: elapsed, justTiming: justTiming): return .perfectGreat
    case isInGreatRange(elpased: elapsed, justTiming: justTiming): return .great
    case isInGoodRange(elpased: elapsed, justTiming: justTiming): return .good
    case isInBadRange(elpased: elapsed, justTiming: justTiming): return .bad
    case isInPoorRange(elpased: elapsed, justTiming: justTiming): return .positivePoor
    default: break
    }
    
    return .negativePoor
  }
  
  func isInJudgeableRange(elpased: Double, justTiming: Double) -> Bool {
    let isOverJudgeLine = elpased - justTiming > 0.0
    
    return isOverJudgeLine ?
      isInBadRange(elpased: elpased, justTiming: justTiming) :
      isInPoorRange(elpased: elpased, justTiming: justTiming)
  }
  
  func isInMissRange(elpased: Double, justTiming: Double) -> Bool {
    let diff = elpased - justTiming
    
    guard diff > 0.0 else {
      return false
    }
    
    return diff > badRange
  }
  
  private func isInPerfectGreatRange(elpased: Double, justTiming: Double) -> Bool {
    return abs(elpased - justTiming) <= pGreatRange
  }
  
  private func isInGreatRange(elpased: Double, justTiming: Double) -> Bool {
    return abs(elpased - justTiming) <= greatRange
  }
  
  private func isInGoodRange(elpased: Double, justTiming: Double) -> Bool {
    return abs(elpased - justTiming) <= goodRange
  }
  
  private func isInBadRange(elpased: Double, justTiming: Double) -> Bool {
    return abs(elpased - justTiming) <= badRange
  }
  
  private func isInPoorRange(elpased: Double, justTiming: Double) -> Bool {
    return abs(elpased - justTiming) <= poorRange
  }
}
