import SpriteKit

class DebugScene: BasicScene<Model, View, Controller<Model, View>> {
  init() {
    super.init(model: nil, view: nil, controller: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
