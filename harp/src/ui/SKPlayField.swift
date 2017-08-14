import SpriteKit

fileprivate let laneSeparatorSize = CGSize(width: 2.0, height: CGFloat(Config.BMS.defaultLaneHeight))
fileprivate let barLineZPosition: CGFloat = 1.0
fileprivate let judgeLineZPosition: CGFloat = 2.0
fileprivate let noteZPosition: CGFloat = 3.0
fileprivate let coverZPosition: CGFloat = 4.0
fileprivate let liftZPosition: CGFloat = 4.0

final class SKPlayField: SKSpriteNode {

  private var lanes = [LaneType: SKLane]()
  private let judgeLine = SKSpriteNode()
  private let lift = SKSpriteNode()
  private let laneCover = SKSpriteNode()
  
  private var barLines = [SKSpriteNode]()
  private var normalNotes = [Int: SKNote]()
  private var longNotes = [Int: SKNote]()

  init(type: SideType) {
    let width: CGFloat
      = SKNote.NoteType.white.size.width * CGFloat(4.0) +
        SKNote.NoteType.black.size.width * CGFloat(3.0) +
        SKNote.NoteType.scratch.size.width * CGFloat(1.0) +
        laneSeparatorSize.width * CGFloat(7.0)

    super.init(texture: nil, color: .black,
               size: CGSize(width: width, height: CGFloat(Config.BMS.defaultLaneHeight)))
    
    judgeLine.size = CGSize(width: width, height: 5.0)
    judgeLine.color = NSColor(named: .judgeLine)
    judgeLine.anchorPoint = CGPoint.zero
    judgeLine.position = CGPoint(x: 0.0, y: 0.0)
    judgeLine.zPosition = judgeLineZPosition
    addChild(judgeLine)
    
    setupLanes(laneOrder: (type == .player1) ?
      [.scratch, .key1, .key2, .key3, .key4, .key5, .key6, .key7] :
      [.key1, .key2, .key3, .key4, .key5, .key6, .key7, .scratch])
    
    lift.anchorPoint = CGPoint.zero
    lift.position = CGPoint.zero
    lift.size = CGSize(width: size.width, height: 0.0)
    lift.color = .gray
    lift.zPosition = liftZPosition
    addChild(lift)
    
    laneCover.anchorPoint = CGPoint(x: 0.0, y: 1.0)
    laneCover.position = CGPoint(x: 0.0, y: size.height)
    laneCover.size = CGSize(width: size.width, height: 0.0)
    laneCover.color = .gray
    laneCover.zPosition = coverZPosition
    addChild(laneCover)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - internal
  
  func updateBarLineCoords(_ coords: [BMSBarLineCoordData]) {
    let shortage = coords.count - barLines.count
    if shortage > 0 {
      for _ in 0..<shortage {
        let line = barLineFactory()
        addChild(line)
        barLines.append(line)
      }
    }

    barLines.forEach {
      $0.isHidden = true
    }

    zip(coords, barLines).forEach {
      $1.position = CGPoint(x: 0.0, y: $0.offsetY + lift.size.height)
      $1.isHidden = false
    }
  }
  
  func updateNormalNoteCoords(_ coords: [BMSBasicNoteCoord]) {
    updateNoteCoords(coords, targetNoteGroup: &normalNotes)
  }
  
  func updateLongNoteCoords(_ coords: [BMSLongNoteCoordData]) {
    updateNoteCoords(coords, targetNoteGroup: &longNotes)

    // Adjust long note feature
    coords.forEach {
      guard let note = longNotes[$0.noteId] else {
        return
      }
      
      note.setLongActive($0.isActive)
      note.setLonglength($0.length)
    }
  }
  
  func setkeyBeamActive(_ isActive: Bool, lane: LaneType) {
    lanes[lane]?.setKeyBeamActive(isActive)
  }
  
  func setLaneCoverHeight(_ height: CGFloat) {
    laneCover.isHidden = height <= 0.0
    laneCover.size.height = height
  }
  
  func setLiftHeight(_ height: CGFloat) {
    lift.isHidden = height <= 0.0
    lift.size.height = height
    
    lanes.forEach { $0.value.position.y = height }
    judgeLine.position.y = height
  }
  
  // MARK: - private
  
  private func updateNoteCoords(_ coords: [BMSBasicNoteCoord],
                                targetNoteGroup: inout [Int: SKNote]) {
    // Remove Notes(already out of fileld) Phase
    targetNoteGroup
      .filter { note in !coords.contains { $0.noteId == note.key } }
      .forEach {
        $0.value.removeFromParent()
        targetNoteGroup.removeValue(forKey: $0.key)
    }
    
    // Place Notes Phase
    coords.forEach {
      if let note = targetNoteGroup[$0.noteId] {
        placeNote(coord: $0, note: note)
      } else {
        
        let newNote = noteFactory(lane: $0.trait.lane)
        
        targetNoteGroup[$0.noteId] = newNote
        placeNote(coord: $0, note: newNote)
      }
    }
  }

  private func placeNote(coord: BMSBasicNoteCoord, note: SKNote) {
    if note.parent == nil, let lane = lanes[coord.trait.lane] {
      lane.addChild(note)
    }
    
    note.position = CGPoint(x: 0.0, y: coord.offsetY)
  }
  
  private func setupLanes(laneOrder: [LaneType]) {
    var laneX: CGFloat = 0.0

    laneOrder.enumerated().forEach { i, laneType in
      let lane = SKLane(noteTypeToHold: SKNote.NoteType.fromLaneType(laneType))
      lane.anchorPoint = CGPoint.zero
      lane.position = CGPoint(x: laneX, y: 0.0)
      addChild(lane)
      
      lanes[laneType] = lane

      if i < laneOrder.count - 1 {
        let laneSeparator = SKSpriteNode(color: NSColor(named: .laneBorder), size: laneSeparatorSize)
        laneSeparator.anchorPoint = CGPoint.zero
        laneSeparator.position = CGPoint(x: laneX + lane.width, y: 0.0)
        addChild(laneSeparator)
        
        laneX += lane.width + laneSeparatorSize.width
      }
    }
  }
  
  private func barLineFactory() -> SKSpriteNode {
    let line = SKSpriteNode()
    line.color = NSColor(named: .barBorder)
    line.size = CGSize(width: self.size.width, height: 2.0)
    line.anchorPoint = CGPoint.zero
    line.zPosition = barLineZPosition
    
    return line
  }
  
  private func noteFactory(lane: LaneType) -> SKNote {
    let note = SKNote(type: SKNote.NoteType.fromLaneType(lane))
    note.anchorPoint = CGPoint.zero
    note.zPosition = noteZPosition
    
    return note
  }
}

fileprivate final class SKLane: SKSpriteNode {
  let width: CGFloat
  let keyBeam = SKSpriteNode(imageNamed: "KeyBeam")

  init(noteTypeToHold: SKNote.NoteType) {
    width = noteTypeToHold.size.width
    
    let size = CGSize(width: width, height: CGFloat(Config.BMS.defaultLaneHeight))
    let color: NSColor = noteTypeToHold == .white ?
      NSColor(named: .laneBgGray) : NSColor(named: .laneBgBlack)

    super.init(texture: nil, color: color, size: size)
    
    keyBeam.anchorPoint = CGPoint(x: 0.5, y: 0.0)
    keyBeam.size.width = size.width
    keyBeam.position = CGPoint(x: size.width * 0.5, y: 0.0)
    keyBeam.isHidden = true
    addChild(keyBeam)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setKeyBeamActive(_ isActive: Bool) {
    keyBeam.isHidden = !isActive
    
    if isActive {
      let action = SKAction.resize(toWidth: size.width, duration: 0.05)
      keyBeam.removeAllActions()
      keyBeam.size.width = size.width - 8.0
      keyBeam.run(action)
    }
  }
}
