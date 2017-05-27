import Foundation
import SpriteKit

class DebugPlayScene: DebugScene {
  
  private let playScene = DIContainer.scene(PlayScene.self)
  private let textField = NSTextField()

  override func didMove(to view: SKView) {
    playScene.didMove(to: view)
    addChild(playScene)
    
    super.didMove(to: view)
  }
  
  override func update(_ currentTime: TimeInterval) {
    playScene.update(currentTime)
  }
}
