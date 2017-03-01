import Foundation
import IOKit
import IOKit.hid
import RxSwift

enum ControllerInput {
  case button
  case axis
  case none
}

fileprivate let criteria: NSDictionary = [
  kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop,
  kIOHIDDeviceUsageKey: kHIDUsage_GD_Joystick
]

fileprivate func bridge<T: AnyObject>(obj: T) -> UnsafeMutableRawPointer {
  return Unmanaged.passUnretained(obj).toOpaque()
}

fileprivate func bridge<T: AnyObject>(ptr: UnsafeRawPointer) -> T {
  return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
}

fileprivate func perseValue(value: IOHIDValue) -> (ControllerInput, Int) {
  let element = IOHIDValueGetElement(value)
  let usage = Int(IOHIDElementGetUsage(element))
  let usagePage = Int(IOHIDElementGetUsagePage(element))
  
  switch usagePage {
  case kHIDPage_Button:         return (.button, usage)
  case kHIDPage_GenericDesktop: return (.axis, usage)
  default:                      return (.none, 0)
  }
}

class HIDDeviceManager {
  private var manager: IOHIDManager?
  fileprivate var subject = PublishSubject<(ControllerInput, Int)>()
  
  init?() {
    manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
  
    guard let manager = manager else {
      return nil
    }
  
    IOHIDManagerSetDeviceMatching(manager, criteria)

    let result = IOHIDManagerOpen(manager, IOOptionBits(kIOHIDOptionsTypeNone))
    guard result == kIOReturnSuccess else {
      return nil
    }
  }
  
  func start() -> Observable<(ControllerInput, Int)> {
    guard let manager = manager else {
      return Observable.error(NSError(domain: "a", code: 299, userInfo: nil))
    }
    
    IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
    IOHIDManagerRegisterInputValueCallback(manager, { (context, result, sender, value) in
      guard let context = context, result == kIOReturnSuccess else {
        return
      }
      
      let persed = perseValue(value: value)
      let selfPtr: HIDDeviceManager = bridge(ptr: context)
      selfPtr.subject.onNext(persed)
    }, bridge(obj: self))

    return subject.asObservable()
  }
}
