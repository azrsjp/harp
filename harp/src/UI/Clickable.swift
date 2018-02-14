import SpriteKit

protocol Clickable {
  /// Callback working in BasicScene
  /// Returns bool presents consume click event
  var onClicked: ((_ event: NSEvent) -> Bool)? { get set }
}
