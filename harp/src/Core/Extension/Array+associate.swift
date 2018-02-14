import Foundation

extension Array {
  func associate<T, U>(_ bundler: (Array.Generator.Element) -> (T?, U?)) -> [T:U] {
    return self.reduce([T:U](), { result, element in
      let bundle = bundler(element)

      if let key = bundle.0, let value = bundle.1 {
        var newResult = result
        newResult[key] = value
        return newResult
      } else {
        return result
      }
    })
  }
}
