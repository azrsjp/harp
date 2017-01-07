import RxSwift

final class ControllerInputToGameEvent {
  private var hidManager: HIDDeviceManager?
  private let subject = PublishSubject<GameEvent>()
  
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
  
  func complete() {
    subject.onCompleted()
  }
  
  private func convertInputToEvent(_ input: HIDInputData) -> GameEvent {
    return .noteOn7
  }
}
