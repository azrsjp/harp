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

// Define joypad input to JoypadInputType converter
fileprivate let kOn = 1
fileprivate let kOff = 0
fileprivate let kAxisPlus = 0
fileprivate let kAxisNuetral = 127
fileprivate let kAxisMinus = 255
fileprivate typealias D = HIDInputData

fileprivate let inputValueMap: [Int:[Int:[Int:HIDInputData]]] = [
  kHIDPage_Button: [
    1:  [kOff: D(.button1, .off),   kOn: D(.button1, .on)], // kHIDUsage_Button_1,
    2:  [kOff: D(.button2, .off),   kOn: D(.button2, .on)], // kHIDUsage_Button_2,
    3:  [kOff: D(.button3, .off),   kOn: D(.button3, .on)], // kHIDUsage_Button_3,
    4:  [kOff: D(.button4, .off),   kOn: D(.button4, .on)], // kHIDUsage_Button_4 exist but
    5:  [kOff: D(.button5, .off),   kOn: D(.button5, .on)], // kHIDUsage_Button_5 do not exist, so use Raw Int
    6:  [kOff: D(.button6, .off),   kOn: D(.button6, .on)],
    7:  [kOff: D(.button7, .off),   kOn: D(.button7, .on)],
    8:  [kOff: D(.button8, .off),   kOn: D(.button8, .on)],
    9:  [kOff: D(.button9, .off),   kOn: D(.button9, .on)],
    10: [kOff: D(.button10, .off),  kOn: D(.button10, .on)],
    11: [kOff: D(.button11, .off),  kOn: D(.button11, .on)],
    12: [kOff: D(.button12, .off),  kOn: D(.button12, .on)],
    13: [kOff: D(.button13, .off),  kOn: D(.button13, .on)],
    14: [kOff: D(.button14, .off),  kOn: D(.button14, .on)],
    15: [kOff: D(.button15, .off),  kOn: D(.button15, .on)],
    16: [kOff: D(.button16, .off),  kOn: D(.button16, .on)]
  ],
  kHIDPage_GenericDesktop: [
    kHIDUsage_GD_X: [kAxisPlus: D(.left, .none), kAxisNuetral: D(.hNeutral, .none), kAxisMinus: D(.right, .none)],
    kHIDUsage_GD_Y: [kAxisPlus: D(.up, .none)  , kAxisNuetral: D(.vNeutral, .none), kAxisMinus: D(.down, .none)]
  ],
  kHIDPage_KeyboardOrKeypad: [
    kHIDUsage_KeyboardA:                [kOff: D(.keyA, .off), kOn: D(.keyA, .on)],
    kHIDUsage_KeyboardB:                [kOff: D(.keyB, .off), kOn: D(.keyB, .on)],
    kHIDUsage_KeyboardC:                [kOff: D(.keyC, .off), kOn: D(.keyC, .on)],
    kHIDUsage_KeyboardD:                [kOff: D(.keyD, .off), kOn: D(.keyD, .on)],
    kHIDUsage_KeyboardE:                [kOff: D(.keyE, .off), kOn: D(.keyE, .on)],
    kHIDUsage_KeyboardF:                [kOff: D(.keyF, .off), kOn: D(.keyF, .on)],
    kHIDUsage_KeyboardG:                [kOff: D(.keyG, .off), kOn: D(.keyG, .on)],
    kHIDUsage_KeyboardH:                [kOff: D(.keyH, .off), kOn: D(.keyH, .on)],
    kHIDUsage_KeyboardI:                [kOff: D(.keyI, .off), kOn: D(.keyI, .on)],
    kHIDUsage_KeyboardJ:                [kOff: D(.keyJ, .off), kOn: D(.keyJ, .on)],
    kHIDUsage_KeyboardK:                [kOff: D(.keyK, .off), kOn: D(.keyK, .on)],
    kHIDUsage_KeyboardL:                [kOff: D(.keyL, .off), kOn: D(.keyL, .on)],
    kHIDUsage_KeyboardM:                [kOff: D(.keyM, .off), kOn: D(.keyM, .on)],
    kHIDUsage_KeyboardN:                [kOff: D(.keyN, .off), kOn: D(.keyN, .on)],
    kHIDUsage_KeyboardO:                [kOff: D(.keyO, .off), kOn: D(.keyO, .on)],
    kHIDUsage_KeyboardP:                [kOff: D(.keyP, .off), kOn: D(.keyP, .on)],
    kHIDUsage_KeyboardQ:                [kOff: D(.keyQ, .off), kOn: D(.keyQ, .on)],
    kHIDUsage_KeyboardR:                [kOff: D(.keyR, .off), kOn: D(.keyR, .on)],
    kHIDUsage_KeyboardS:                [kOff: D(.keyS, .off), kOn: D(.keyS, .on)],
    kHIDUsage_KeyboardT:                [kOff: D(.keyT, .off), kOn: D(.keyT, .on)],
    kHIDUsage_KeyboardU:                [kOff: D(.keyU, .off), kOn: D(.keyU, .on)],
    kHIDUsage_KeyboardV:                [kOff: D(.keyV, .off), kOn: D(.keyV, .on)],
    kHIDUsage_KeyboardW:                [kOff: D(.keyW, .off), kOn: D(.keyW, .on)],
    kHIDUsage_KeyboardX:                [kOff: D(.keyX, .off), kOn: D(.keyX, .on)],
    kHIDUsage_KeyboardY:                [kOff: D(.keyY, .off), kOn: D(.keyY, .on)],
    kHIDUsage_KeyboardZ:                [kOff: D(.keyZ, .off), kOn: D(.keyZ, .on)],
    kHIDUsage_Keyboard1:                [kOff: D(.key1, .off), kOn: D(.key1, .on)],
    kHIDUsage_Keyboard2:                [kOff: D(.key2, .off), kOn: D(.key2, .on)],
    kHIDUsage_Keyboard3:                [kOff: D(.key3, .off), kOn: D(.key3, .on)],
    kHIDUsage_Keyboard4:                [kOff: D(.key4, .off), kOn: D(.key4, .on)],
    kHIDUsage_Keyboard5:                [kOff: D(.key5, .off), kOn: D(.key5, .on)],
    kHIDUsage_Keyboard6:                [kOff: D(.key6, .off), kOn: D(.key6, .on)],
    kHIDUsage_Keyboard7:                [kOff: D(.key7, .off), kOn: D(.key7, .on)],
    kHIDUsage_Keyboard8:                [kOff: D(.key8, .off), kOn: D(.key8, .on)],
    kHIDUsage_Keyboard9:                [kOff: D(.key9, .off), kOn: D(.key9, .on)],
    kHIDUsage_Keyboard0:                [kOff: D(.key0, .off), kOn: D(.key0, .on)],
    kHIDUsage_KeyboardReturnOrEnter:    [kOff: D(.keyEnter, .off), kOn: D(.keyEnter, .on)],
    kHIDUsage_KeyboardEscape:           [kOff: D(.keyEscape, .off), kOn: D(.keyEscape, .on)],
    kHIDUsage_KeyboardTab:              [kOff: D(.keyTab, .off), kOn: D(.keyTab, .on)],
    kHIDUsage_KeyboardSpacebar:         [kOff: D(.keySpace, .off), kOn: D(.keySpace, .on)],
    kHIDUsage_KeyboardLeftShift:        [kOff: D(.keyShiftL, .off), kOn: D(.keyShiftL, .on)],
    kHIDUsage_KeyboardLeftControl:      [kOff: D(.keyControlL, .off), kOn: D(.keyControlL, .on)],
    kHIDUsage_KeyboardLeftAlt:          [kOff: D(.keyAltL, .off), kOn: D(.keyAltL, .on)]
  ]
]

class HIDDeviceManager {
  private var isRunning = false
  private var manager: IOHIDManager
  fileprivate var subject = PublishSubject<HIDInputData>()

  deinit {
    stop()
    IOHIDManagerClose(manager, IOOptionBits(kIOHIDOptionsTypeNone))
  }

  init?() {
    manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))

    IOHIDManagerSetDeviceMatchingMultiple(manager, criteria as CFArray)
    IOHIDManagerRegisterDeviceMatchingCallback(manager, onDeviceAttached, Bridge.toCPtr(obj: self))
    IOHIDManagerRegisterDeviceRemovalCallback(manager, onDeviceRemoved, Bridge.toCPtr(obj: self))
    IOHIDManagerRegisterInputValueCallback(manager, onInputValue, Bridge.toCPtr(obj: self))

    let result = IOHIDManagerOpen(manager, IOOptionBits(kIOHIDOptionsTypeNone))
    guard result == kIOReturnSuccess else {
      return nil
    }
  }

  func start() -> Observable<HIDInputData> {
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
  
  // Callbacks for IOHIDManager
  private let onInputValue: IOHIDValueCallback = { (context, result, sender, value) in
    guard let context = context, result == kIOReturnSuccess else {
      return
    }
    
    let selfRef: HIDDeviceManager = Bridge.toSwiftRef(ptr: context)
    let parsed = selfRef.parseValue(value)
    selfRef.subject.onNext(parsed)
  }
  
  private let onDeviceAttached: IOHIDDeviceCallback = { (context, result, sender, device) in
    guard result == kIOReturnSuccess else {
      return
    }
    
    let deviceName = IOHIDDeviceGetProperty(device, kIOHIDProductKey as CFString)
    Logger.info("onDeviceAttach: \(deviceName)")
  }
  
  private let onDeviceRemoved: IOHIDDeviceCallback = { (context, result, sender, device) in
    guard result == kIOReturnSuccess else {
      return
    }
    
    let deviceName = IOHIDDeviceGetProperty(device, kIOHIDProductKey as CFString)
    Logger.info("onDeviceRemoved: \(deviceName)")
  }
  
  fileprivate func parseValue(_ value: IOHIDValue) -> HIDInputData {
    let element = IOHIDValueGetElement(value)
    let usagePage = Int(IOHIDElementGetUsagePage(element))
    let usage = Int(IOHIDElementGetUsage(element))
    let intValue = IOHIDValueGetIntegerValue(value)
    //  let device = IOHIDElementGetDevice(element)
    //  let serial = IOHIDDeviceGetProperty(device, kIOHIDSerialNumberKey as CFString)
    //  let name = IOHIDDeviceGetProperty(device, kIOHIDProductKey as CFString)
    //  Logger.info(("uasgePage: \(usagePage), usage: \(usage), int: \(intValue)")
    
    return inputValueMap[usagePage]?[usage]?[intValue] ?? D(.unknown, .none)
  }
}
