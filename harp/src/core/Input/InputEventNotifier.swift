import RxSwift

protocol HIDInputConverter {
  associatedtype EventType
  func toEvent(_ input: HIDInputData) -> EventType
}

final class HIDInputConverterForInGame: HIDInputConverter {
  func toEvent(_ input: HIDInputData) -> GameEvent {
    // TODO: Implement
    return GameEvent.noteOn1
  }
}

final class InputEventNotifier<T: HIDInputConverter> {
  private let hidManager: HIDDeviceManager?
  private let converter: T

  init?(converter: T) {
    guard let hidManager = HIDDeviceManager() else {
      return nil
    }
    
    self.hidManager = hidManager
    self.converter = converter
  }
  
  func observable() -> Observable<T.EventType> {
    return hidManager!.start()
      .filter { $0.type != .unknown}
      .map { input -> T.EventType in
        return self.converter.toEvent(input)
      }
  }
}
