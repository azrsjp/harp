import Foundation

// Define event type on playing game

enum GameEvent: String {
  case noteOn1          = "noteOn1"
  case noteOn2          = "noteOn2"
  case noteOn3          = "noteOn3"
  case noteOn4          = "noteOn4"
  case noteOn5          = "noteOn5"
  case noteOn6          = "noteOn6"
  case noteOn7          = "noteOn7"
  case noteOff1         = "noteOff1"
  case noteOff2         = "noteOff2"
  case noteOff3         = "noteOff3"
  case noteOff4         = "noteOff4"
  case noteOff5         = "noteOff5"
  case noteOff6         = "noteOff6"
  case noteOff7         = "noteOff7"
  case scrachLeft       = "scrachLeft"
  case scrachRight      = "scrachRight"
  case scrachEnd        = "scrachEnd"
  case hispeedUp        = "hispeedUp"
  case hispeedDown      = "hispeedDown"
  case suddenPlusUp     = "suddenPlusUp"
  case suddenPlusDown   = "suddenPlusDown"
  case liftUp           = "liftUp"
  case liftDown         = "liftDown"
  case switchLift       = "switchLift"
  case switchSuddenPlus = "switchSuddenPlus"
  case exit             = "exit"
}
