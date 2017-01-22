import Foundation
import Swinject

struct DIContainer {
  static func scene<Scene: BasicScene>(_ scene: Scene.Type) -> Scene {
    return container.resolve(scene)!
  }
}

fileprivate let container = Container() { c in

}
