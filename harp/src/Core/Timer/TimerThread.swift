import Foundation

final class TimerThread: Thread {
  private var block: ((_ elapsedSec: Double) -> Void)?
  private var interval = 0.00001
  private var timer = Timer()
  private var origin: Double = 0.0

  var elapsedSec: Double {
    return origin + timer.elapsedSec
  }

  func start(interval: Double = 0.00001, origin: Double,
             block: @escaping ((_ elapsedSec: Double) -> Void)) {
    self.origin = origin
    self.block = block

    start()
  }

  override func start() {
    self.timer.start()

    super.start()
  }

  override func main() {
    guard let block = self.block else {
      cancel()
      return
    }

    while isExecuting {
      block(elapsedSec)
      Thread.sleep(forTimeInterval: interval)
    }
  }
}
