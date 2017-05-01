import Foundation

extension Array {
  subscript (safe index: Int) -> Element? {
    get {

      return indices ~= index ? self[index] : nil
    }
    set (value) {
      guard let value_ = value else {
        return
      }

      if !((indices) ~= index) {
        Logger.warning("index:\(index) is out of range, so ignored.")
        return
      }

      self[index] = value_
    }
  }
}
