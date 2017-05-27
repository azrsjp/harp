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
    model.judge(event: event)

    switch event {
    case .noteOn1:
      model.playKeySound(side: .player1, lane: .key1)
    case .noteOn2:
      model.playKeySound(side: .player1, lane: .key2)
    case .noteOn3:
      model.playKeySound(side: .player1, lane: .key3)
    case .noteOn4:
      model.playKeySound(side: .player1, lane: .key4)
    case .noteOn5:
      model.playKeySound(side: .player1, lane: .key5)
    case .noteOn6:
      model.playKeySound(side: .player1, lane: .key6)
    case .noteOn7:
      model.playKeySound(side: .player1, lane: .key7)
    case .scrachRight: fallthrough
    case .scrachLeft:
      model.playKeySound(side: .player1, lane: .scratch)
    default:
      break
    }
  }
  
  override func rightMouseDown(with event: NSEvent) -> Bool {
    exitScene()
    
    return true
  }
}
