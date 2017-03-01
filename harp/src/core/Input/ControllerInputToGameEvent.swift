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
    
    return hidManager.start().map({ value -> GameEvent in
      if value.0 == .button {
        return self.convertButtonNoToKey(number: value.1)
      }

      return .noteOn7
    })
  }
  
  func complete() {
    subject.onCompleted()
  }
  
  private func convertButtonNoToKey(number: Int) -> GameEvent {
    return .noteOn7
  }
}
