import Foundation

enum NoteType: Int {
  case visible = 1
  case invisible = 2
  case longStart = 3
  case longEnd = 4
  
  // Note channel 11-69 will be note type
  // All channel 5x-6x notes will be longStart(=3),
  // some notes need to be re-define as longEnd.
  
  init?(channel: Int) {
    guard let side = SideType(channel: channel) else {
      return nil
    }
    
    self.init(rawValue: ((channel / 10) + 2 - side.rawValue) / 2)
  }
}
