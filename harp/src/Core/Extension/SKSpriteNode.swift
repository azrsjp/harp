import SpriteKit

extension SKSpriteNode {
  func moveBy(x: CGFloat, y: CGFloat) {
    position.x += x
    position.y += y
  }
  
  func moveBy(_ diff: CGPoint) {
    position += diff
  }
}
