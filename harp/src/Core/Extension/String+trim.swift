import Foundation

extension String {
  func trim() -> String {
    return trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
