import SpriteKit

// Place pairs(label on menu, scene generator)

// Viewgroup for experiments
fileprivate let debugs: [(String, () -> SKScene)] = [
  ("UI Components", { DebugUIComponentsScene() }),
  ("Judge", { DebugJudgeScene() }),
  ("InputKeys", { DebugInputKeysScene() })
]

// Viewgroup for on product
fileprivate let views: [(String, () -> SKScene)] = [
  ("Start", { StartScene() })
]

final class DebugMenuScene: BasicScene {

  override func didMove(to view: SKView) {
    super.didMove(to: view)

    generateMenuButtons()
  }

  private func generateMenuButtons() {
    // Closure to generate button in alignment
    let placer = { (pairs: [(String, () -> SKScene)], index: Int, offsetX: CGFloat) in
      let label = pairs[index].0
      let scene = pairs[index].1()

      let button = TextButton(text: label)
      let y = self.size.height - (10.0 + button.fontSize) * CGFloat(index)
      button.fontName = Config.Common.defaultFontName
      button.position = CGPoint(x: offsetX, y: y - 20.0)
      button.horizontalAlignmentMode = .left
      button.verticalAlignmentMode = .top
      button.onClicked = { _ in
        self.view?.presentScene(scene)
      }

      self.addChild(button)
    }

    for i in 0..<debugs.count {
      placer(debugs, i, 20.0)
    }
    
    for i in 0..<views.count {
      placer(views, i, 400.0)
    }
  }
}
