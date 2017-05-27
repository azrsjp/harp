import SpriteKit
import RxSwift

protocol PlayControllerDelegate: class {
  func playControllerWillExitScene()
}

class PlayController: Controller<PlayModel, PlayView> {
  weak var delegate: PlayControllerDelegate?
  
  private let disposeBag = DisposeBag()
  private var notifier: InputEventNotifier<HIDInputConverterForInGame>?

  override func initialize() {
    view.model = model

    notifier = InputEventNotifier(converter: HIDInputConverterForInGame())

    guard let notifier = notifier else {
      return
    }

    notifier.observable().subscribe(onNext: { [weak self] event in
      guard let self_ = self else {
        return
      }
      
      self_.handleGameEvent(event)
    }).addDisposableTo(disposeBag)
  }
  
  // MARK: - private
  
  private func exitScene() {
    delegate?.playControllerWillExitScene()
  }
  
  private func handleGameEvent(_ event: GameEvent) {
    
    if let (lane, side) = event.sideAndLane {
      view.setKeyBeamActive(event.isKeyDownEvent, lane: lane)
      
      model.judge(event: event)

      if event.isKeyDownEvent {
        model.playKeySound(side: side, lane: lane)
      }
    }
    
    switch event {
    case .suddenPlusUp: model.addCoverCount(10.0)
    case .suddenPlusDown: model.addCoverCount(-10.0)
    case .liftUp: model.addLiftCount(10.0)
    case .liftDown: model.addLiftCount(-10.0)
    default: break
    }
  }
  
  override func rightMouseDown(with event: NSEvent) -> Bool {
    exitScene()
    
    return true
  }
}
