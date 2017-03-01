import SpriteKit

protocol Clickable {
  var onClicked: ((SKNode) -> Void)? { get set }
}
