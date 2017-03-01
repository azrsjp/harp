import Quick
import Nimble
@testable import harp

class CGSizeOperatorSpec: QuickSpec {
  override func spec() {
    describe("四則演算"){
      let former: CGSize = CGSize(width: 100.0, height: 50.0)
      let latter: CGSize = CGSize(width: 20.0, height: 70.0)
      let factor: CGFloat = 2.0

      context("足し算"){
        it("f + l = (width: f.width + l.width, height:  f.height + l.height)") {
          let value: CGSize = former + latter
          expect(value).to(equal(CGSize(width: former.width + latter.width, height: former.height + latter.height)))
        }
      }
      
      context("引き算"){
        it("f - l = (width: f.width - l.width, height:  f.height - l.height)") {
          let value: CGSize = former - latter
          expect(value).to(equal(CGSize(width: former.width - latter.width, height: former.height - latter.height)))
        }
      }
      
      context("掛け算"){
        it("f * factor = (width: f.width * factor, height:  f.height * factor)") {
          let value: CGSize = former * factor
          expect(value).to(equal(CGSize(width: former.width * factor, height: former.height * factor)))
        }
      }
      
      context("割り算"){
        it("f / factor = (width: f.width / factor, height:  f.height / factor)") {
          let value: CGSize = former / factor
          expect(value).to(equal(CGSize(width: former.width / factor, height: former.height / factor)))
        }
      }
    }
  }
}
