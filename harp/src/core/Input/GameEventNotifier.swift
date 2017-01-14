import RxSwift

final class GameEventNotifier {
  private var hidManager: HIDDeviceManager?
  
  init() {
    hidManager = HIDDeviceManager()
  }
  
  func observable() -> Observable<GameEvent> {
    guard let hidManager = hidManager else {
      return Observable.of(GameEvent.hispeedDown).asObservable()
    }
    
    return hidManager.start().filter({ $0.type != .unknown}).map({ input -> GameEvent in
      return self.convertInputToEvent(input)
    })
  }

  private func convertInputToEvent(_ input: HIDInputData) -> GameEvent {
    return .noteOn7
  }
}
