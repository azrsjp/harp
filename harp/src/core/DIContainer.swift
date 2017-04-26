import Foundation
import Swinject
import SpriteKit

struct DIContainer {
  static func scene<Scene: SKScene>(_ scene: Scene.Type) -> Scene {
    return container.resolve(scene)!
  }
}

fileprivate let container = Container { c in
  c.register(StartScene.self) { _ in
    let m = StartModel()
    let v = StartView()
    let c = StartController(model: m, view: v)
    let scene = StartScene(model: m, view: v, controller: c)
    
    return scene
  }
}
