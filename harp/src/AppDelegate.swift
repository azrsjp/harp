import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet private weak var window: NSWindow!
  @IBOutlet private weak var mainView: SKView!

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let windowSize = Config.Common.defaultWindowSize

    window.setContentSize(windowSize)
    window.contentMinSize = windowSize / 2
    window.contentAspectRatio = windowSize

    #if DEBUG
      let scene = DebugMenuScene()

      mainView.showsFPS = true
      mainView.showsNodeCount = true
      mainView.showsDrawCount = true
    #else
      let scene = StartScene()
    #endif

    mainView.ignoresSiblingOrder = true
    mainView.presentScene(scene)
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}
