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
}
