import Foundation

enum NoteType: Int {
  case visible = 1
  case invisible = 2
  case long = 3
  
  // Note channel 11-59 will be note type
  
  init?(channel: Int) {
    guard let side = SideType(channel: channel) else {
      return nil
    }
    
    self.init(rawValue: ((channel / 10) + 2 - side.rawValue) / 2)
  }
}
