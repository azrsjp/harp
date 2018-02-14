import Foundation

infix operator ?=
func ?=<T> (left: inout T, right: T?) {
  left = right ?? left
}
