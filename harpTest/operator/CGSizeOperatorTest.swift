import Quick
import Nimble
@testable import harp

class CGSizeOperatorTest: QuickSpec {
  override func spec() {
    describe("its operator"){
      let former: CGSize = CGSize(width: 100.0, height: 50.0)
      let latter: CGSize = CGSize(width: 20.0, height: 70.0)
      let factor: CGFloat = 2.0

      it("f + l = (width: f.width + l.width, height:  f.height + l.height)") {
        let value: CGSize = former + latter
        expect(value).to(equal(CGSize(width: former.width + latter.width, height: former.height + latter.height)))
      }
      
      it("f - l = (width: f.width - l.width, height:  f.height - l.height)") {
        let value: CGSize = former - latter
        expect(value).to(equal(CGSize(width: former.width - latter.width, height: former.height - latter.height)))
      }
      
      it("f * factor = (width: f.width * factor, height:  f.height * factor)") {
        let value: CGSize = former * factor
        expect(value).to(equal(CGSize(width: former.width * factor, height: former.height * factor)))
      }

      it("f / factor = (width: f.width / factor, height:  f.height / factor)") {
        let value: CGSize = former / factor
        expect(value).to(equal(CGSize(width: former.width / factor, height: former.height / factor)))
      }
    }
  }
}
