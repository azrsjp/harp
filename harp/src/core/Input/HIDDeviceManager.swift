import Foundation
import IOKit
import IOKit.hid
import RxSwift

// Detect keyboard and joypads used on this app
let criteria: [NSDictionary] = [
  [
    kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop,
    kIOHIDDeviceUsageKey: kHIDUsage_GD_Joystick
  ],
  [
    kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop,
    kIOHIDDeviceUsageKey: kHIDUsage_GD_Keyboard
  ]
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
  ],
  kHIDPage_KeyboardOrKeypad: [
    kHIDUsage_KeyboardA: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardB: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardC: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardD: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardE: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardF: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardG: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardH: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardI: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardJ: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardK: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardL: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardM: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardN: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardO: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardP: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardQ: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardR: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardS: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardT: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardU: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardV: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardW: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardX: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardY: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardZ: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_Keyboard1: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_Keyboard2: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_Keyboard3: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_Keyboard4: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_Keyboard5: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_Keyboard6: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_Keyboard7: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_Keyboard8: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_Keyboard9: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_Keyboard0: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardReturnOrEnter: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardEscape: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardDeleteOrBackspace: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardTab: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardSpacebar: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardCapsLock: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardLeftControl: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardLeftShift: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardLeftAlt: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardRightControl: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardRightShift: [Input.off: .buttonOff1, Input.on: .buttonOn1],
    kHIDUsage_KeyboardRightAlt: [Input.off: .buttonOff1, Input.on: .buttonOn1]
  ]
]

fileprivate func parseValue(_ value: IOHIDValue) -> JoypadInputType {
  let element = IOHIDValueGetElement(value)
  let usagePage = Int(IOHIDElementGetUsagePage(element))
  let usage = Int(IOHIDElementGetUsage(element))
  let intValue = IOHIDValueGetIntegerValue(value)
//  let device = IOHIDElementGetDevice(element)
//  let serial = IOHIDDeviceGetProperty(device, kIOHIDSerialNumberKey as CFString)
//  let name = IOHIDDeviceGetProperty(device, kIOHIDProductKey as CFString)
//  Logger.info(("uasgePage: \(usagePage), usage: \(usage), int: \(intValue)")
  
  return inputValueMap[usagePage]?[usage]?[intValue] ?? .unknown
}

// Callbacks for IOHIDManager
fileprivate let onInputValue: IOHIDValueCallback = { (context, result, sender, value) in
  guard let context = context, result == kIOReturnSuccess else {
    return
  }

  let parsed = parseValue(value)
  let selfRef: HIDDeviceManager = bridge(ptr: context)
  selfRef.subject.onNext(parsed)
}

fileprivate let onDeviceAttached: IOHIDDeviceCallback = { (context, result, sender, device) in
  guard result == kIOReturnSuccess else {
    return
  }

  let deviceName = IOHIDDeviceGetProperty(device, kIOHIDProductKey as CFString)
  Logger.info("onDeviceAttach: \(deviceName)")
}

fileprivate let onDeviceRemoved: IOHIDDeviceCallback = { (context, result, sender, device) in
  guard result == kIOReturnSuccess else {
    return
  }

  let deviceName = IOHIDDeviceGetProperty(device, kIOHIDProductKey as CFString)
  Logger.info("onDeviceRemoved: \(deviceName)")
}

class HIDDeviceManager {
  private var isRunning = false
  private var manager: IOHIDManager
  fileprivate var subject = PublishSubject<JoypadInputType>()

  deinit {
    stop()
    IOHIDManagerClose(manager, IOOptionBits(kIOHIDOptionsTypeNone))
  }

  init?() {
    manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
    IOHIDManagerSetDeviceMatchingMultiple(manager, criteria as CFArray)
    IOHIDManagerRegisterDeviceMatchingCallback(manager, onDeviceAttached, bridge(obj: self))
    IOHIDManagerRegisterDeviceRemovalCallback(manager, onDeviceRemoved, bridge(obj: self))
    IOHIDManagerRegisterInputValueCallback(manager, onInputValue, bridge(obj: self))

    let result = IOHIDManagerOpen(manager, IOOptionBits(kIOHIDOptionsTypeNone))
    guard result == kIOReturnSuccess else {
      return nil
    }
  }

  func start() -> Observable<JoypadInputType> {
    if !isRunning {
      IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
      isRunning = true
    }

    return subject.asObservable()
  }

  func stop() {
    if isRunning {
      IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
      isRunning = false
    }
  }
}
