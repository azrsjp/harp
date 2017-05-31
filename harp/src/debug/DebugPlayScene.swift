import Foundation
import SpriteKit

class DebugPlayScene: DebugScene {
  
  private var playScene = DIContainer.scene(PlayScene.self)
  private let bmsPathField = NSTextField()
  private let loadButton = NSButton()
  private let slider = NSSlider()

  override func didMove(to view: SKView) {
    super.didMove(to: view)

    playScene.didMove(to: view)
    addChild(playScene)

    bmsPathField.stringValue = "/Absolute/Path/to/BMSfile"
    bmsPathField.frame.size = NSSize(width: 400.0, height: 30.0)
    bmsPathField.frame.origin = NSPoint(x: 400.0, y: view.frame.height - 40.0)
    view.addSubview(bmsPathField)
    
    loadButton.title = "Start"
    loadButton.frame.size = NSSize(width: 80.0, height: 30.0)
    loadButton.frame.origin = NSPoint(x: 800.0, y: view.frame.height - 40.0)
    loadButton.action = #selector(onClickLoad)
    loadButton.target = self
    view.addSubview(loadButton)
  }

  @objc private func onClickLoad() {
    playScene.removeFromParent()
    playScene = DIContainer.scene(PlayScene.self)
    playScene.didMove(to: view!)
    addChild(playScene)
    
    Logger.info("Try to load \(self.bmsPathField.stringValue)")

    playScene.m.loadBMSFileAndIntialize(fullFilePath: bmsPathField.stringValue,
                                        originSec: 0.0)
  }
  
  override func willMove(from view: SKView) {
    bmsPathField.removeFromSuperview()
    loadButton.removeFromSuperview()
    slider.removeFromSuperview()
  }

  override func update(_ currentTime: TimeInterval) {
    playScene.update(currentTime)
  }
  
  override func keyDown(with event: NSEvent) {
    
  }
}
