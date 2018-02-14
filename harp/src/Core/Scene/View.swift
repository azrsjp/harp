import Foundation
import SpriteKit

class View: SKNode {
  // Override if want to update views per frames
  func update(_ currentTime: TimeInterval) {}
  
  // Override if want to initialize properties of views on display
  func constructView(sceneSize: CGSize) {}
}
