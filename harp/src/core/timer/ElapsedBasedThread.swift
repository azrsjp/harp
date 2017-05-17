import Foundation

final class ElapsedBasedThread: Thread {
  private var startTime: UInt64 = 0
  private var interval: TimeInterval = 0.00001
  private var process: ((Double) -> Void) = {_ in }
  private var info = mach_timebase_info_data_t()
  
  func start(interval: TimeInterval = 0.00001, process: @escaping (Double) -> Void) {
    guard KERN_SUCCESS == mach_timebase_info(&info) else {
      cancel()
      return
    }

    self.interval = interval
    self.process = process
    startTime = mach_absolute_time()
    
    start()
  }
  
  override func main() {
    while !isCancelled {
      process(calcElapsed())
      Thread.sleep(forTimeInterval: interval)
    }
  }
  
  func calcElapsed() -> TimeInterval {
    let currentTime = mach_absolute_time()
    
    let elapsedNanos = (currentTime - startTime) * UInt64(info.numer) / UInt64(info.denom)
    let elapsedSeconds = Double(elapsedNanos) * 0.000000001
    
    return elapsedSeconds
  }
}
