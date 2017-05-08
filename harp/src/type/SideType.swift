import Foundation

enum SideType: Int {
  case player1 = 1
  case player2 = 2
  
  // Note channel 11-59 will be side type
  
  init?(channel: Int) {
    self.init(rawValue: 2 - ((channel / 10) % 2))
  }
}
