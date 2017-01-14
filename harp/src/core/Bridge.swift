import Foundation

// Define swift ref <-> pointer converter (working with c++ functions)
struct Bridge {
  static func toCPtr<T: AnyObject>(obj: T) -> UnsafeMutableRawPointer {
    return Unmanaged.passUnretained(obj).toOpaque()
  }
  
  static func toSwiftRef<T: AnyObject>(ptr: UnsafeRawPointer) -> T {
    return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
  }
}
