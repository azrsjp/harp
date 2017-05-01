import Quick
import Nimble
@testable import harp

class CGPointOperatorTest: QuickSpec {
  override func spec() {
    describe("its operator"){
      let former: CGPoint = CGPoint(x: 100.0, y: 50.0)
      let latter: CGPoint = CGPoint(x: 20.0, y: 70.0)
      let factor: CGFloat = 2.0
      
      it("f + l = (x: f.x + l.x, y:  f.y + l.y)") {
        let value: CGPoint = former + latter
        expect(value).to(equal(CGPoint(x: former.x + latter.x, y: former.y + latter.y)))
      }

      it("f - l = (x: f.x - l.x, y:  f.y - l.y)") {
        let value: CGPoint = former - latter
        expect(value).to(equal(CGPoint(x: former.x - latter.x, y: former.y - latter.y)))
      }

      it("f * factor = (x: f.x * factor, y:  f.y * factor)") {
        let value: CGPoint = former * factor
        expect(value).to(equal(CGPoint(x: former.x * factor, y: former.y * factor)))
      }

      it("f / factor = (x: f.x / factor, y:  f.y / factor)") {
        let value: CGPoint = former / factor
        expect(value).to(equal(CGPoint(x: former.x / factor, y: former.y / factor)))
      }
    }
  }
}
