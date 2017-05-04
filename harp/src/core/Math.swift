import Foundation

final class Math {
  static func gcd(_ m: Int, _ n: Int) -> Int {
    var a = 0
    var b = max(m, n)
    var r = min(m, n)
    
    while r != 0 {
      a = b
      b = r
      r = a % b
    }
    return b
  }
  
  static func lcm(_ m: Int, _ n: Int) -> Int {
    return m * n / Math.gcd(m, n)
  }
}
