import Quick
import Nimble
@testable import harp

class AnyOperatorTest: QuickSpec {
  override func spec() {
    describe("Any Operator") {
      describe("its ?=") {

        context("right value is nil") {
          it("left value is still its value") {
            var leftString: String = "left value"
            let rightString: String? = nil

            var leftInt: Int = 100
            let rightInt: Int? = nil

            leftString ?= rightString
            expect(leftString).to(equal("left value"))

            leftInt ?= rightInt
            expect(leftInt).to(equal(100))
          }
        }

        context("right value is not nil") {
          it("left value is equal to right value") {
            var leftString: String = "left value"
            let rightString: String? = "right value"

            var leftInt: Int = 100
            let rightInt: Int? = 200

            leftString ?= rightString
            expect(leftString).to(equal("right value"))

            leftInt ?= rightInt
            expect(leftInt).to(equal(200))
          }
        }
      }
    }
  }
}
