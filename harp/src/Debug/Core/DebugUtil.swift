import Foundation

final class DebugUtil {

  static func measureTime(_ description: String = "", _ block: () -> Void) {
    let start = Date()
    
    block()

    let elapsed = Date().timeIntervalSince(start)
    
    Logger.debug("\(description), elapsed: \(elapsed)")
  }
}
