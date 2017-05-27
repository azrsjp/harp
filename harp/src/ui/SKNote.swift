import SpriteKit

final class SKNote: SKSpriteNode {
  
  private var type: NoteType
  private lazy var longSprite: SKSpriteNode? = self.makeLong()

  init(type: NoteType) {
    self.type = type

    super.init(texture: nil,
               color: type.color,
               size: type.size)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - internal
  
  func setLonglength(_ length: CGFloat) {
    guard let long = longSprite else {
      return
    }
    
    long.size.height = length
  }
  
  func setLongActive(_ isActive: Bool) {
    guard let long = longSprite else {
      return
    }
    
    long.color = isActive ? type.longActiveColor : type.longInactiveColor
  }
  
  // MARK: - private

  private func makeLong() -> SKSpriteNode {
    let long = SKSpriteNode(color: type.longInactiveColor,
                            size: CGSize(width: type.longWidth, height: 0.0))
    long.anchorPoint = CGPoint.zero
    long.position = CGPoint(x: (size.width - type.longWidth) / 2.0, y: size.height)
    addChild(long)
    
    return long
  }
  
  enum NoteType {
    case white
    case black
    case scratch
    
    static func fromLaneType(_ type: LaneType) -> NoteType {
      switch type {
      case .key1: fallthrough
      case .key3: fallthrough
      case .key5: fallthrough
      case .key7: return .white
      case .key2: fallthrough
      case .key4: fallthrough
      case .key6: return .black
      case .scratch: return .scratch
      }
    }
    
    static let all: [NoteType] = [.white, .black, .scratch]

    var color: NSColor {
      switch self {
      case .white: return NSColor(named: .noteWhite)
      case .black: return NSColor(named: .noteBlack)
      case .scratch: return NSColor(named: .noteScratch)
      }
    }
    
    var size: CGSize {
      switch self {
      case .white: return Config.BMS.whiteNoteSize
      case .black: return Config.BMS.blackNoteSize
      case .scratch: return Config.BMS.scratchNoteSize
      }
    }
    
    var longInactiveColor: NSColor {
      switch self {
      case .white: return .gray
      case .black: return .gray
      case .scratch: return .gray
      }
    }
    
    var longActiveColor: NSColor {
      switch self {
      case .white: return .white
      case .black: return .white
      case .scratch: return .white
      }
    }
    
    var longWidth: CGFloat {
      return size.width - 4.0
    }
  }
}
