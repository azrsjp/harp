import Foundation

extension String {
  func splitBy(length: Int) -> [String]? {
    guard length > 0 else {
      return nil
    }

    let endIdx = self.endIndex
    var idx = self.startIndex
    var result = [String]()

    while idx != endIdx {
      let start = idx
      idx = index(idx, offsetBy: length, limitedBy: endIdx) ?? endIdx

      result.append(self[start..<idx])
    }
    
    return result.count > 0 ? result : nil
  }
}
