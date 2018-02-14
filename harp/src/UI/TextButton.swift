import SpriteKit

class TextButton: SKLabelNode, Clickable {
  var onClicked: ((_ event: NSEvent) -> Bool)?
}
