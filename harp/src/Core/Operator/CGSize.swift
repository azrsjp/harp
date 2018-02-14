import Foundation

func + (left: CGSize, right: CGSize) -> CGSize {
  let width = left.width + right.width
  let height = left.height + right.height

  return CGSize(width: width, height: height)
}

func - (left: CGSize, right: CGSize) -> CGSize {
  let width = left.width - right.width
  let height = left.height - right.height
  
  return CGSize(width: width, height: height)
}

func * (left: CGSize, right: CGFloat) -> CGSize {
  let width = left.width * right
  let height = left.height * right
  
  return CGSize(width: width, height: height)
}

func / (left: CGSize, right: CGFloat) -> CGSize {
  let width = left.width / right
  let height = left.height / right
  
  return CGSize(width: width, height: height)
}

func += (left: inout CGSize, right: CGSize) {
  left = left + right
}

func -= (left: inout CGSize, right: CGSize) {
  left = left - right
}

func *= (left: inout CGSize, right: CGFloat) {
  left = left * right
}

func /= (left: inout CGSize, right: CGFloat) {
  left = left / right
}
