import SpriteKit

class PlayScene: BasicScene<PlayModel, PlayView, PlayController>, PlayControllerDelegate {
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    
    c.delegate = self
    
    backgroundColor = .white
  }
  
  func loadBMSFile(fullFilePath: String) {
    m.loadBMSFileAndIntialize(fullFilePath: fullFilePath)
  }
  
  // MARK: - PlayControllerDelegate
  
  func playControllerWillExitScene() {
    view?.presentScene(DebugMenuScene())
  }
}
