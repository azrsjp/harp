import Foundation

final class Timer {
  private var startTime: UInt64 = 0
  private let numer: UInt64
  private let denom: UInt64

  init() {
    var info = mach_timebase_info()
    mach_timebase_info(&info)

    numer = UInt64(info.numer)
    denom = UInt64(info.denom)
  }

  // MARK: - internal

  func start() {
    startTime = mach_absolute_time()
  }

  var elapsedNs: UInt64 {
    return (elapsed() * numer) / denom
  }

  var elapsedMs: Double {
    return Double(elapsedNs) / 1_000_000
  }

  var elapsedSec: Double {
    return Double(elapsedNs) / 1_000_000_000
  }

  // MARK: - private

  private func elapsed() -> UInt64 {
    return mach_absolute_time() - startTime
  }
}
