import Foundation
import IOKit
import IOKit.hid
import RxSwift

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

fileprivate let inputValueMap: [Int:[Int:[Int:JoypadInputType]]] = [
  kHIDPage_Button: [
    1: [0: .buttonOff1, 1: .buttonOn1], // kHIDUsage_Button_1,
    2: [0: .buttonOff2, 1: .buttonOn2], // kHIDUsage_Button_2,
    3: [0: .buttonOff3, 1: .buttonOn3], // kHIDUsage_Button_3,
    4: [0: .buttonOff4, 1: .buttonOn4], // kHIDUsage_Button_4 exist but
    5: [0: .buttonOff5, 1: .buttonOn5], // kHIDUsage_Button_5 do not exist, so use Raw Int
    6: [0: .buttonOff6, 1: .buttonOn6],
    7: [0: .buttonOff7, 1: .buttonOn7],
    8: [0: .buttonOff8, 1: .buttonOn8],
    9: [0: .buttonOff9, 1: .buttonOn9],
    10: [0: .buttonOff10, 1: .buttonOn10],
    11: [0: .buttonOff11, 1: .buttonOn11],
    12: [0: .buttonOff12, 1: .buttonOn12],
    13: [0: .buttonOff13, 1: .buttonOn13],
    14: [0: .buttonOff14, 1: .buttonOn14],
    15: [0: .buttonOff15, 1: .buttonOn15],
    16: [0: .buttonOff16, 1: .buttonOn16]
  ],
  kHIDPage_GenericDesktop: [
    kHIDUsage_GD_X: [0: .left, 127: .hNeutral, 255: .right],
    kHIDUsage_GD_Y: [0: .up, 127: .vNeutral, 255: .down]
  ]
]

fileprivate func parseValue(_ value: IOHIDValue) -> JoypadInputType {
  let element = IOHIDValueGetElement(value)
  let usage = Int(IOHIDElementGetUsage(element))
  let usagePage = Int(IOHIDElementGetUsagePage(element))
  let intValue = IOHIDValueGetIntegerValue(value)

  return inputValueMap[usagePage]?[usage]?[intValue] ?? .unknown
}

class HIDDeviceManager {
  private var manager: IOHIDManager?
  private var subject = PublishSubject<JoypadInputType>()

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

  func start() -> Observable<JoypadInputType> {
    guard let manager = manager else {
      return Observable.error(NSError(domain: "a", code: 299, userInfo: nil))
    }
    
    IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
    IOHIDManagerRegisterInputValueCallback(manager, { (context, result, sender, value) in
      guard let context = context, result == kIOReturnSuccess else {
        return
      }
      
      let parsed = parseValue(value)
      let selfRef: HIDDeviceManager = bridge(ptr: context)
      selfRef.subject.onNext(parsed)
    }, bridge(obj: self))

    return subject.asObservable()
  }
}
