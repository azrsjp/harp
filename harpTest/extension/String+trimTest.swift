import Quick
import Nimble
@testable import harp

class StringTrimTest: QuickSpec {
  override func spec() {
    describe("String") {
      describe("#trim") {
        context("when has half-space or full-space or tab-char or linebreak-char at beginning and end of line") {
          let string = " test sample string　\n\r \t 　"

          it("is trimed these space chars") {
            let result = string.trim()
            expect(result).to(equal("test sample string"))
          }
        }

        context("when has no half-space or full-space or tab-char or linebreak-char at beginning and end of line") {
          let string = "test sample string"

          it("is trimed nothing") {
            let result = string.trim()
            expect(result).to(equal("test sample string"))
          }
        }
      }
    }
  }
}
