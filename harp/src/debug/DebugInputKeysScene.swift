import SpriteKit
import RxSwift

class DebugInputKeysScene: BasicScene {
  let label = SKLabelNode(text: "")
  let disposeBag = DisposeBag()
  var notifier: GameEventNotifier?
  
  override func didMove(to view: SKView) {
    super.didMove(to: view)

    // Setup debug indicator
    label.text = "EveneName"
    label.position = CGPoint(x: size.width / 2, y:  size.height / 2)
    addChild(label)

    notifier = GameEventNotifier(scene: self)
    
    // Subscribe event stream
    if let notifier = notifier {

      notifier.observable().subscribe(onNext: { event in
        self.label.text = event.rawValue
        Logger.debug(event)
        
        if event == GameEvent.exit {
          self.notifier?.stopNofitying()
        }
      }).addDisposableTo(disposeBag)
    }
  }
}
