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
    static let defaultLaneHeight: Double = 720.0
    
    static let pGreatRange: Double = 0.020
    static let greatRange: Double = 0.040
    static let goodRange: Double = 0.105
    static let badRange: Double = 0.150
    static let poorRange: Double = 1.0
  }
}
