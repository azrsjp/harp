import SpriteKit
import RxSwift

final class GameEventNotifier {
  // Note: - Prepare InputToGameEvent protorol?
  private let keyboard = KeyboardInputToGameEvent()
  private let controller = ControllerInputToGameEvent()
  
  init?(scene: SKScene) {
    guard let window = scene.view?.window else {
      return nil
    }
    
    guard window.makeFirstResponder(keyboard) else {
      return nil
    }
  }

  func observable() -> Observable<GameEvent> {
    let forKeyboard = keyboard.observable()
    let forController = controller.observable()

    return Observable.of(forKeyboard, forController).merge()
  }

  func stopNofitying() {
    keyboard.complete()
    controller.complete()
  }
}
