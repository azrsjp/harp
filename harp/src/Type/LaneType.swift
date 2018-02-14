import Foundation

/// Note: - rawValue is refering to general BMS key:number mapping rule.

enum LaneType: Int {
  case scratch = 6
  case key1 = 1
  case key2 = 2
  case key3 = 3
  case key4 = 4
  case key5 = 5
  case key6 = 8
  case key7 = 9
  
  static let values: [LaneType]
    = [.scratch, .key1, .key2, .key3, .key4, .key5, .key6, .key7]
  
  // Note channel 11-69 will be lane type
  
  init?(channel: Int) {
    self.init(rawValue: channel % 10)
  }
}
