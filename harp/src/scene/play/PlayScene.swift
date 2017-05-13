import SpriteKit

class PlayScene: BasicScene<PlayModel, PlayView, PlayController> {
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    
    backgroundColor = .white
  }
  
  func loadBMSFile(fullFilePath: String) {
    m.loadBMSFileAndIntialize(fullFilePath: fullFilePath)
  }
}
