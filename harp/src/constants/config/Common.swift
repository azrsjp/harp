import Foundation

struct Config {
  struct Common {
    static let defaultWidth: CGFloat = 1920.0
    static let defaultHeight: CGFloat = 1080.0
    static let defaultWindowSize = CGSize(width: defaultWidth, height: defaultHeight)
    
    static let defaultFontName = "Helvetica"
  }
  
  struct BMS {
    static let resolution: Int = 480 * 14
    static let baseBarTick: Int = resolution * 4
    static let keyForRest: String = "00"
    static let defaultBarHeight: Double = 480.0
  }
}
