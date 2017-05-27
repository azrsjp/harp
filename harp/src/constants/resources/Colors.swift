// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  typealias Color = UIColor
#elseif os(OSX)
  import AppKit.NSColor
  typealias Color = NSColor
#endif

extension Color {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum ColorName {
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#868686"></span>
  /// Alpha: 100% <br/> (0x868686ff)
  case barBorder
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#e86161"></span>
  /// Alpha: 100% <br/> (0xe86161ff)
  case judgeLine
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#0a0a0a"></span>
  /// Alpha: 100% <br/> (0x0a0a0aff)
  case laneBgBlack
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#1e1e1e"></span>
  /// Alpha: 100% <br/> (0x1e1e1eff)
  case laneBgGray
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#595959"></span>
  /// Alpha: 100% <br/> (0x595959ff)
  case laneBorder
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#6199e8"></span>
  /// Alpha: 100% <br/> (0x6199e8ff)
  case noteBlack
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#e86161"></span>
  /// Alpha: 100% <br/> (0xe86161ff)
  case noteScratch
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f9f9f9"></span>
  /// Alpha: 100% <br/> (0xf9f9f9ff)
  case noteWhite

  var rgbaValue: UInt32 {
    switch self {
    case .barBorder: return 0x868686ff
    case .judgeLine: return 0xe86161ff
    case .laneBgBlack: return 0x0a0a0aff
    case .laneBgGray: return 0x1e1e1eff
    case .laneBorder: return 0x595959ff
    case .noteBlack: return 0x6199e8ff
    case .noteScratch: return 0xe86161ff
    case .noteWhite: return 0xf9f9f9ff
    }
  }

  var color: Color {
    return Color(named: self)
  }
}
// swiftlint:enable type_body_length

extension Color {
  convenience init(named name: ColorName) {
    self.init(rgbaValue: name.rgbaValue)
  }
}
