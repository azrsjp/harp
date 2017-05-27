import SpriteKit

class PlayView: View {
  
  var model: PlayModel?

  private var field = SKPlayField(type: .player1)
  private let combo = SKLabelNode()
  private let judge = SKLabelNode()
  
  override func constructView(sceneSize: CGSize) {
    field.anchorPoint = CGPoint.zero
    field.position = CGPoint(x: 15.0, y: sceneSize.height - field.size.height)
    addChild(field)
  
    combo.position = CGPoint(x: 200.0, y: 140.0)
    combo.fontColor = .white
    combo.horizontalAlignmentMode = .left
    field.addChild(combo)

    judge.position = CGPoint(x: 200.0, y: 140.0)
    judge.fontColor = .white
    judge.horizontalAlignmentMode = .right
    field.addChild(judge)
  }
  
  func setKeyBeamActive(_ isActive: Bool, lane: LaneType) {
    field.setkeyBeamActive(isActive, lane: lane)
  }

  override func update(_ currentTime: TimeInterval) {
    guard let model = model, let coords = model.currentCoordData() else {
      return
    }

    field.updateBarLineCoords(coords.barLines)
    field.updateNormalNoteCoords(coords.notes)
    field.updateLongNoteCoords(coords.longNotes)
    field.setLaneCoverHeight(coords.coverHeight)
    field.setLiftHeight(coords.liftHeight)

    combo.text = String(coords.combo)
    judge.text = String(coords.judge)
  }
}
