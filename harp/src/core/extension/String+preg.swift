import Foundation

extension String {
  var count: Int {
    return (self as NSString).length
  }

  func pregMatche(pattern: String, options: NSRegularExpression.Options = []) -> [String] {
    guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
      return [String]()
    }
    let targetStringRange = NSRange(location: 0, length: count)
    let results = regex.matches(in: self, options: [], range: targetStringRange)

    var matches = [String]()

    results.forEach {
      for i in 0 ..< $0.numberOfRanges {
        let range = $0.rangeAt(i)
        matches.append((self as NSString).substring(with: range))
      }
    }

    return matches
  }

  func pregMatcheFirst(pattern: String, options: NSRegularExpression.Options = []) -> String? {
    guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
      return nil
    }
    let targetStringRange = NSRange(location: 0, length: count)
    let results = regex.matches(in: self, options: [], range: targetStringRange)

    for i in 0 ..< results.count {
      for j in 0 ..< results[i].numberOfRanges {
        let range = results[i].rangeAt(j)
        return (self as NSString).substring(with: range)
      }
    }

    return nil
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
