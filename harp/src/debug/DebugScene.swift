import SpriteKit

class DebugScene: BasicScene<Model, View, Controller<Model, View>> {
  init() {
    let m = Model()
    let v = View()
    let c = Controller(model: m, view: v)

    super.init(model: m, view: v, controller: c)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
