import Foundation

func + (left: CGPoint, right: CGPoint) -> CGPoint {
  let x = left.x + right.x
  let y = left.y + right.y
  
  return CGPoint(x: x, y: y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
  let x = left.x - right.x
  let y = left.y - right.y
  
  return CGPoint(x: x, y: y)
}

func * (left: CGPoint, right: CGFloat) -> CGPoint {
  let x = left.x * right
  let y = left.y * right
  
  return CGPoint(x: x, y: y)
}

func / (left: CGPoint, right: CGFloat) -> CGPoint {
  let x = left.x / right
  let y = left.y / right
  
  return CGPoint(x: x, y: y)
}

func += (left: inout CGPoint, right: CGPoint) {
  left = left + right
}

func -= (left: inout CGPoint, right: CGPoint) {
  left = left - right
}

func *= (left: inout CGPoint, right: CGFloat) {
  left = left * right
}

func /= (left: inout CGPoint, right: CGFloat) {
  left = left / right
}
