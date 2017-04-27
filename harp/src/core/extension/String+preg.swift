import Foundation

extension String {
  var count: Int {
    return (self as NSString).length
  }

  func pregMatche(pattern: String, options: NSRegularExpression.Options = []) -> Bool {
    guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
      return false
    }

    let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: count))
    return matches.count > 0
  }

  func pregMatche(pattern: String, options: NSRegularExpression.Options = [], matches: inout [String]) -> Bool {
    guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
      return false
    }
    let targetStringRange = NSRange(location: 0, length: count)
    let results = regex.matches(in: self, options: [], range: targetStringRange)

    results.forEach {
      for i in 0 ..< $0.numberOfRanges {
        let range = $0.rangeAt(i)
        matches.append((self as NSString).substring(with: range))
      }
    }

    return results.count > 0
  }

  func pregReplace(pattern: String, with: String, options: NSRegularExpression.Options = []) -> String {
    guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
      return pattern
    }

    return regex.stringByReplacingMatches(in: self,
                                          options: [],
                                          range: NSRange(location: 0, length: count),
                                          withTemplate: with)
  }
}
