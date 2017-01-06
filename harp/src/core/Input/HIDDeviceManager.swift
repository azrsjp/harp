import Foundation
import IOKit
import IOKit.hid
import RxSwift

// Define matching conditions for Joypads used on this app
fileprivate let criteria: NSDictionary = [
  kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop,
  kIOHIDDeviceUsageKey: kHIDUsage_GD_Joystick
]

// Define swift ref <-> pointer converter (working with c++ functions)
fileprivate func bridge<T: AnyObject>(obj: T) -> UnsafeMutableRawPointer {
  return Unmanaged.passUnretained(obj).toOpaque()
}

fileprivate func bridge<T: AnyObject>(ptr: UnsafeRawPointer) -> T {
  return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
}

// Define joypad input to JoypadInputType converter
fileprivate struct Input {
  static let on = 1
  static let off = 0
  static let axisPlus = 0
  static let axisNuetral = 127
  static let axisMinus = 255
}

fileprivate let inputValueMap: [Int:[Int:[Int:JoypadInputType]]] = [
  kHIDPage_Button: [
    1:  [Input.off: .buttonOff1,  Input.on: .buttonOn1], // kHIDUsage_Button_1,
    2:  [Input.off: .buttonOff2,  Input.on: .buttonOn2], // kHIDUsage_Button_2,
    3:  [Input.off: .buttonOff3,  Input.on: .buttonOn3], // kHIDUsage_Button_3,
    4:  [Input.off: .buttonOff4,  Input.on: .buttonOn4], // kHIDUsage_Button_4 exist but
    5:  [Input.off: .buttonOff5,  Input.on: .buttonOn5], // kHIDUsage_Button_5 do not exist, so use Raw Int
    6:  [Input.off: .buttonOff6,  Input.on: .buttonOn6],
    7:  [Input.off: .buttonOff7,  Input.on: .buttonOn7],
    8:  [Input.off: .buttonOff8,  Input.on: .buttonOn8],
    9:  [Input.off: .buttonOff9,  Input.on: .buttonOn9],
    10: [Input.off: .buttonOff10, Input.on: .buttonOn10],
    11: [Input.off: .buttonOff11, Input.on: .buttonOn11],
    12: [Input.off: .buttonOff12, Input.on: .buttonOn12],
    13: [Input.off: .buttonOff13, Input.on: .buttonOn13],
    14: [Input.off: .buttonOff14, Input.on: .buttonOn14],
    15: [Input.off: .buttonOff15, Input.on: .buttonOn15],
    16: [Input.off: .buttonOff16, Input.on: .buttonOn16]
  ],
  kHIDPage_GenericDesktop: [
    kHIDUsage_GD_X: [Input.axisPlus: .left, Input.axisNuetral: .hNeutral, Input.axisMinus: .right],
    kHIDUsage_GD_Y: [Input.axisPlus: .up,   Input.axisNuetral: .vNeutral, Input.axisMinus: .down]
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
