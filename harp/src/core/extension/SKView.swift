import SpriteKit

extension SKView {
  override open func flagsChanged(with event: NSEvent) {
    scene?.flagsChanged(with: event)
  }
}
