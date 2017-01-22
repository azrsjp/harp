import Foundation

class Controller<M: Model, V: View> {
  let model: M
  let view: V
  
  init(model: M, view: V) {
    self.model = model
    self.view = view
  }
}
