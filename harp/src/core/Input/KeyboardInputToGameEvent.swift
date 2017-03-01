import RxSwift

final class KeyboardInputToGameEvent: NSResponder {
  private let subject = PublishSubject<GameEvent>()
  private var resignable = false
  
  func observable() -> Observable<GameEvent> {
    return subject.asObservable().observeOn(MainScheduler.instance)
  }
  
  // Call to free first responder privelege
  func makeResignable() {
    resignable = true
  }

  func complete() {
    makeResignable()
    subject.onCompleted()
  }

  private func detectKey(event: NSEvent, isOn: Bool) {
    // TODO: apply keyconfig
    switch event.keyCode {
    case 6: subject.onNext(isOn ? .noteOn1 : .noteOff1)
    case 1: subject.onNext(isOn ? .noteOn2 : .noteOff2)
    case 7: subject.onNext(isOn ? .noteOn3 : .noteOff3)
    case 2: subject.onNext(isOn ? .noteOn4 : .noteOff4)
    case 8: subject.onNext(isOn ? .noteOn5 : .noteOff5)
    case 3: subject.onNext(isOn ? .noteOn6 : .noteOff6)
    case 9: subject.onNext(isOn ? .noteOn7 : .noteOff7)
    default: break
    }
  }
  
  private func detectScrach(event: NSEvent) {
    if event.modifierFlags.contains(NSShiftKeyMask) {
      // TODO: - Continuous and Backspin Scratch
      subject.onNext(.scrachLeft)
    }
  }
  
  private func detectConfig(event: NSEvent) {
    let isOnShiftKey = event.modifierFlags.contains(NSShiftKeyMask)
    let isOnControlKey = event.modifierFlags.contains(NSControlKeyMask)

    switch event.keyCode {
    case 126: // up arrow
      if isOnShiftKey {
        subject.onNext(.suddenPlusUp)
      } else if isOnControlKey {
        subject.onNext(.liftUp)
      } else {
        subject.onNext(.hispeedUp)
      }
    case 125: // down arrow
      if isOnShiftKey {
        subject.onNext(.suddenPlusDown)
      } else if isOnControlKey {
        subject.onNext(.liftDown)
      } else {
        subject.onNext(.hispeedDown)
      }
    case 53: // esc
      subject.onNext(.exit)
    default: break
    }
  }
  
  // MARK: - NSResponder
  
  override func resignFirstResponder() -> Bool {
    return resignable
  }
  
  override func keyDown(with event: NSEvent) {
    detectKey(event: event, isOn: true)
    detectConfig(event: event)
  }

  override func keyUp(with event: NSEvent) {
    detectKey(event: event, isOn: false)
  }

  override func flagsChanged(with event: NSEvent) {
    detectScrach(event: event)
  }
}
