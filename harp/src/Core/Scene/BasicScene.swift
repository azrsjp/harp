import SpriteKit

// Fundamental class for scene in harp project
// Every scene should inherit BasicScene

class BasicScene<M: Model, V: View, C:Controller<M, V>>: SKScene {
  let m: M
  let v: V
  let c: C
  
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

  init(model: M, view: V, controller: C) {
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
    
    c.initialize()
  }
  
  override func keyDown(with event: NSEvent) {
    guard !c.keyDown(with: event) else {
      return
    }
  }
  
  override func mouseDown(with event: NSEvent) {
    guard !c.mouseDown(with: event) else {
      return
    }

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
  
  override func rightMouseDown(with event: NSEvent) {
    guard !c.rightMouseDown(with: event) else {
      return
    }
  }
  
  override func update(_ currentTime: TimeInterval) {
    super.update(currentTime)
    
    rootView?.update(currentTime)
  }
}
