import SpriteKit

class TextButton: SKLabelNode, Clickable {
  var onClicked: ((SKNode) -> Void)?
}
