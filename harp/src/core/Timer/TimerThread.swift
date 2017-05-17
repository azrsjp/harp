import Foundation

final class TimerThread: Thread {
  private var block: ((_ elapsedSec: Double) -> Void)?
  private var interval = 0.00001
  private var timer = Timer()

  var elapsedSec: Double {
    return timer.elapsedSec
  }

  func start(interval: Double = 0.00001, block: @escaping ((_ elapsedSec: Double) -> Void)) {
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
      block(timer.elapsedSec)
      Thread.sleep(forTimeInterval: interval)
    }
  }
}
