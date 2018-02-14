import Foundation
import SpriteKit

class Controller<M: Model, V: View> {
  let model: M
  let view: V
  
  init(model: M, view: V) {
    self.model = model
    self.view = view
  }
  
  func initialize() {}
  
  func keyDown(with event: NSEvent) -> Bool {
    return false
  }
  
  func mouseDown(with event: NSEvent) -> Bool {
    return false
  }
  
  func rightMouseDown(with event: NSEvent) -> Bool {
    return false
  }
}
