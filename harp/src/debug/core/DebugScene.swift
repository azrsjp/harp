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
  
  override func didMove(to view: SKView) {
    super.didMove(to: view)

    putButtonToDebugScene()
  }
  
  // All scene hold the button to return to DebugScene only in DEBUG mode
  // But excludes DebugMenuScene
  func putButtonToDebugScene() {
    guard className != DebugMenuScene.className() else {
      return
    }
    
    let padding: CGFloat = 20.0 // escaping to overray debug info
    let button = TextButton(text: "Return to DebugMenuScene")
    
    button.fontName = Config.Common.defaultFontName
    button.fontColor = NSColor.white
    button.verticalAlignmentMode = .bottom
    button.horizontalAlignmentMode = .right
    button.position = CGPoint(x: frame.width - padding, y: padding)
    button.zPosition = CGFloat(FP_INFINITE)
    button.onClicked = { [weak self] _ in
      self?.view?.presentScene(DebugMenuScene())
      
      return true
    }
    
    addChild(button)
  }
}
