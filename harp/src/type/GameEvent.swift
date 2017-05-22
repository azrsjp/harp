import Foundation

// Define event type on playing game

enum GameEvent: String {
  case noteOn1          = "NoteOn1"
  case noteOn2          = "NoteOn2"
  case noteOn3          = "NoteOn3"
  case noteOn4          = "NoteOn4"
  case noteOn5          = "NoteOn5"
  case noteOn6          = "NoteOn6"
  case noteOn7          = "NoteOn7"
  case noteOff1         = "NoteOff1"
  case noteOff2         = "NoteOff2"
  case noteOff3         = "NoteOff3"
  case noteOff4         = "NoteOff4"
  case noteOff5         = "NoteOff5"
  case noteOff6         = "NoteOff6"
  case noteOff7         = "NoteOff7"
  case scrachLeft       = "ScrachLeft"
  case scrachRight      = "ScrachRight"
  case scrachEnd        = "ScrachEnd"
  case hispeedUp        = "HispeedUp"
  case hispeedDown      = "HispeedDown"
  case suddenPlusUp     = "SuddenPlusUp"
  case suddenPlusDown   = "SuddenPlusDown"
  case liftUp           = "LiftUp"
  case liftDown         = "LiftDown"
  case switchLift       = "SwitchLift"
  case switchSuddenPlus = "SwitchSuddenPlus"
  case exit             = "Exit"

  var isKeyDownEvent: Bool {
    switch self {
    case .noteOn1: fallthrough
    case .noteOn2: fallthrough
    case .noteOn3: fallthrough
    case .noteOn4: fallthrough
    case .noteOn5: fallthrough
    case .noteOn6: fallthrough
    case .noteOn7: fallthrough
    case .scrachLeft: fallthrough
    case .scrachRight: return true
    case .noteOff1: fallthrough
    case .noteOff2: fallthrough
    case .noteOff3: fallthrough
    case .noteOff4: fallthrough
    case .noteOff5: fallthrough
    case .noteOff6: fallthrough
    case .noteOff7: fallthrough
    case .scrachEnd: return false
    default: return false
    }
  }

  var sideAndLane: (LaneType, SideType)? {
    switch self {
    case .noteOn1: fallthrough
    case .noteOff1: return (.key1, .player1)
    case .noteOn2: fallthrough
    case .noteOff2:  return (.key2, .player1)
    case .noteOn3: fallthrough
    case .noteOff3:  return (.key3, .player1)
    case .noteOn4: fallthrough
    case .noteOff4:  return (.key4, .player1)
    case .noteOn5: fallthrough
    case .noteOff5:  return (.key5, .player1)
    case .noteOn6: fallthrough
    case .noteOff6:  return (.key6, .player1)
    case .noteOn7: fallthrough
    case .noteOff7:  return (.key7, .player1)
    case .scrachLeft: fallthrough
    case .scrachRight: fallthrough
    case .scrachEnd: return (.scratch, .player1)
    default: return nil
    }
  }
}
