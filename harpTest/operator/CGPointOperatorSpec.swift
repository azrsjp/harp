import Quick
import Nimble
@testable import harp

class CGPointOperatorSpec: QuickSpec {
  override func spec() {
    describe("四則演算"){
      let former: CGPoint = CGPoint(x: 100.0, y: 50.0)
      let latter: CGPoint = CGPoint(x: 20.0, y: 70.0)
      let factor: CGFloat = 2.0
      
      context("足し算"){
        it("f + l = (x: f.x + l.x, y:  f.y + l.y)") {
          let value: CGPoint = former + latter
          expect(value).to(equal(CGPoint(x: former.x + latter.x, y: former.y + latter.y)))
        }
      }
      
      context("引き算"){
        it("f - l = (x: f.x - l.x, y:  f.y - l.y)") {
          let value: CGPoint = former - latter
          expect(value).to(equal(CGPoint(x: former.x - latter.x, y: former.y - latter.y)))
        }
      }
      
      context("掛け算"){
        it("f * factor = (x: f.x * factor, y:  f.y * factor)") {
          let value: CGPoint = former * factor
          expect(value).to(equal(CGPoint(x: former.x * factor, y: former.y * factor)))
        }
      }
      
      context("割り算"){
        it("f / factor = (x: f.x / factor, y:  f.y / factor)") {
          let value: CGPoint = former / factor
          expect(value).to(equal(CGPoint(x: former.x / factor, y: former.y / factor)))
        }
      }
    }
  }
}
