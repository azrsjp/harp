import Quick
import Nimble
@testable import harp

class ArraySafeTest: QuickSpec {
  override func spec() {
    describe("Array") {
      describe("[safe: index]") {

        let array = ["a", "b", "c", "d", "e"]

        it("returns optinal item at index in array range") {
          expect(array[safe: 0]! == array[0]).to(beTrue())
          expect(array[safe: 1]! == array[1]).to(beTrue())
          expect(array[safe: 2]! == array[2]).to(beTrue())
          expect(array[safe: 3]! == array[3]).to(beTrue())
          expect(array[safe: 4]! == array[4]).to(beTrue())
        }

        it("returns nil at index in array range") {
          expect(array[safe: 0]).notTo(beNil())
          expect(array[safe: 0]!).to(equal("a"))

          expect(array[safe: 5]).to(beNil())
          expect(array[safe: -1]).to(beNil())
        }
      }
    }
  }
}
