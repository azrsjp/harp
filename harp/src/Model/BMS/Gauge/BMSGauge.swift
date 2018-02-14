import Foundation

protocol BMSGauge {
  var total: Double { get }
  var noteNum: Double { get }
  var value: Double { get }
  var revisedValue: Int { get }

  init(total: Int, noteNum: Int)

  func applyJudge(judge: Judge) -> Int
}
