import SpriteKit

class PlayScene: BasicScene<PlayModel, PlayView, PlayController> {
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    
    backgroundColor = .white
  }
}
