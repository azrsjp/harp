import SpriteKit

class StartScene: BasicScene {

  override func didMove(to view: SKView) {
    super.didMove(to: view)
  
    let myLabel = SKLabelNode(text: "Hello, World!")
    myLabel.fontColor = NSColor.black
    myLabel.fontSize = 45
    myLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
    backgroundColor = NSColor.white

    addChild(myLabel)
  }
}
