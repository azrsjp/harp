import Foundation

struct HIDInputData {
  let type: HIDInputType
  let value: HIDInputValue

  init(_ type: HIDInputType, _ value: HIDInputValue) {
    self.type = type
    self.value = value
  }
}

enum HIDInputValue: String {
  case on       = "On"
  case off      = "Off"
  case none     = "None"
}

enum HIDInputType: String {
  // For JoyPads
  case button1    = "Button1"
  case button2    = "Button2"
  case button3    = "Button3"
  case button4    = "Button4"
  case button5    = "Button5"
  case button6    = "Button6"
  case button7    = "Button7"
  case button8    = "Button8"
  case button9    = "Button9"
  case button10   = "Button10"
  case button11   = "Button11"
  case button12   = "Button12"
  case button13   = "Button13"
  case button14   = "Button14"
  case button15   = "Button15"
  case button16   = "Button16"
  case up         = "Up"
  case down       = "Down"
  case vNeutral   = "V-Neutral"
  case left       = "Left"
  case right      = "Right"
  case hNeutral   = "H-Neutral"

  // For Keyboard
  case keyA            = "A"
  case keyB            = "B"
  case keyC            = "C"
  case keyD            = "D"
  case keyE            = "E"
  case keyF            = "F"
  case keyG            = "G"
  case keyH            = "H"
  case keyI            = "I"
  case keyJ            = "J"
  case keyK            = "K"
  case keyL            = "L"
  case keyM            = "M"
  case keyN            = "N"
  case keyO            = "O"
  case keyP            = "P"
  case keyQ            = "Q"
  case keyR            = "R"
  case keyS            = "S"
  case keyT            = "T"
  case keyU            = "U"
  case keyV            = "V"
  case keyW            = "W"
  case keyX            = "X"
  case keyY            = "Y"
  case keyZ            = "Z"
  case key1            = "1"
  case key2            = "2"
  case key3            = "3"
  case key4            = "4"
  case key5            = "5"
  case key6            = "6"
  case key7            = "7"
  case key8            = "8"
  case key9            = "9"
  case key0            = "0"
  case keyEnter        = "Enter"
  case keyEscape       = "Escape"
  case keyTab          = "Tab"
  case keySpace        = "Space"
  case keyShiftL       = "Shift-L"
  case keyControlL     = "Control-L"
  case keyAltL         = "Alt-L"

  // Anything else
  case unknown = "Unknown"
}
