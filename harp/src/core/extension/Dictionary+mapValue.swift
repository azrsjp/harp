import Foundation

extension Dictionary {
  func mapValue(_ mapper: (Value) -> Value) -> [Key:Value] {
    var result = [Key:Value]()

    for (k, v) in self {
      result[k] = mapper(v)
    }

    return result
  }
}
