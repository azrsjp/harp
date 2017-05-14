import SpriteKit

protocol PlayControllerDelegate: class {
  func playControllerWillExitScene()
}

class PlayController: Controller<PlayModel, PlayView> {
  weak var delegate: PlayControllerDelegate?
  
  // MARK: - private
  
  private func exitScene() {
    delegate?.playControllerWillExitScene()
  }
  
  override func rightMouseDown(with event: NSEvent) -> Bool {
    exitScene()
    
    return true
  }
}
