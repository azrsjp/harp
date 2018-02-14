import Foundation

enum Judge: String {
  case perfectGreat   = "PerfectGreat"
  case great          = "Great"
  case good           = "Good"
  case bad            = "Bad"
  case negativePoor   = "negativePoor" // arise when through keys
  case positivePoor   = "positivePoor" // arise when pushing keys ahead of timing or in late
  case notYet         = "notYet"
}
