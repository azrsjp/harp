import Foundation

final class HIDInputConverterForInGame: HIDInputConverter {
  func toEvent(_ input: HIDInputData) -> GameEvent {

    // TODO: - This is temporary mapping, should use use setting to handle custom keys

    switch input.type {
      // for Keyboard
      case .keyShiftL: return input.value == .on ? .scrachLeft : .scrachEnd
      case .keyZ: return input.value == .on ? .noteOn1 : .noteOff1
      case .keyS: return input.value == .on ? .noteOn2 : .noteOff2
      case .keyX: return input.value == .on ? .noteOn3 : .noteOff3
      case .keyD: return input.value == .on ? .noteOn4 : .noteOff4
      case .keyC: return input.value == .on ? .noteOn5 : .noteOff5
      case .keyF: return input.value == .on ? .noteOn6 : .noteOff6
      case .keyV: return input.value == .on ? .noteOn7 : .noteOff7

      // for PS2 IIDX controler
      case .button4: return input.value == .on ? .noteOn1 : .noteOff1
      case .button7: return input.value == .on ? .noteOn2 : .noteOff2
      case .button3: return input.value == .on ? .noteOn3 : .noteOff3
      case .button8: return input.value == .on ? .noteOn4 : .noteOff4
      case .button2: return input.value == .on ? .noteOn5 : .noteOff5
      case .button5: return input.value == .on ? .noteOn6 : .noteOff6
      case .left: return .noteOn7
      case .hNeutral: return .noteOff7
      case .down: return .scrachLeft
      case .up: return .scrachRight
      case .vNeutral: return .scrachEnd
      default: return GameEvent.exit
    }
  }
}
