import SpriteKit

class StartScene: BasicScene<StartModel, StartView, StartController> {
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    
    backgroundColor = .white
  }
}
