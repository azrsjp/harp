import SpriteKit

// Fundamental class for scene in harp project
// Every scene should inherit BasicScene

class BasicScene<M: Model, V: View, C>: SKScene {
  let m: M?
  let v: V?
  let c: C?
  
  var rootView: View? {
    willSet {
      if let rootView = self.rootView {
        rootView.removeFromParent()
      }
    }
    didSet {
      if let rootView = self.rootView {
        rootView.constructView(sceneSize: size)
        insertChild(rootView, at: 0)
      }
    }
  }

  init(model: M?, view: V?, controller: C?) {
    m = model
    v = view
    c = controller
    
    super.init(size: Config.Common.defaultWindowSize)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func didMove(to view: SKView) {
    super.didMove(to: view)
    
    // Size of scene always fits with view frame
    size = Config.Common.defaultWindowSize
    scaleMode = .aspectFill
    
    // Setup root view
    rootView = v

    #if DEBUG
      putButtonToDebugScene()
    #endif
  }
  
  override func mouseDown(with event: NSEvent) {
    let location = event.location(in: self)
    let clickedNodes = nodes(at: location)

    clickedNodes.forEach {
      // Propagate event if not consumed
      if let node = $0 as? Clickable,
         let isConsumedEvent = node.onClicked?(event),
         isConsumedEvent {
        return
      }
    }
  }
  
  override func update(_ currentTime: TimeInterval) {
    super.update(currentTime)
    
    rootView?.update(currentTime)
  }

#if DEBUG
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
#endif
}
