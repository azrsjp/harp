import SpriteKit

class PlayView: View {
  let myLabel = SKLabelNode(text: "Hello, World!")
  
  override func constructView(sceneSize: CGSize) {
    myLabel.fontColor = NSColor.black
    myLabel.fontSize = 45
    myLabel.position = CGPoint(x: sceneSize.width / 2, y: sceneSize.height / 2)
    
    addChild(myLabel)
  }
}
