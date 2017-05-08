import Quick
import Nimble
@testable import harp

class BMSControlFlowDataParserTest: QuickSpec {
  override func spec() {
    describe("BMSControlFlowDataParser") {
      describe("#parse") {

        let parser = BMSControlFlowParser()

        it("enter if block") {
          expect(parser.getParsedData()).to(beFalse())
          expect(parser.parse("#RANDOM 1")).to(beTrue())
          expect(parser.getParsedData()).to(beTrue())
          expect(parser.parse("#00517:00BBCC")).to(beFalse())
          expect(parser.getParsedData()).to(beTrue())
          expect(parser.parse("#IF 1")).to(beTrue())
          expect(parser.getParsedData()).to(beFalse())
          expect(parser.parse("#ENDIF")).to(beTrue())

          expect(parser.getParsedData()).to(beFalse())

          expect(parser.parse("#IF 2")).to(beTrue())
          expect(parser.getParsedData()).to(beTrue())
          expect(parser.parse("#ENDIF")).to(beTrue())

          expect(parser.parse("#IF 1")).to(beTrue())
          expect(parser.getParsedData()).to(beFalse())
          expect(parser.parse("#ENDIF")).to(beTrue())
        }

        it("pass if block") {
          expect(parser.getParsedData()).to(beFalse())
          expect(parser.parse("#RANDOM 100")).to(beTrue())
          expect(parser.getParsedData()).to(beTrue())
          expect(parser.parse("#15011:00BBCCAAAAAA")).to(beFalse())
          expect(parser.getParsedData()).to(beTrue())
          expect(parser.parse("#IF 101")).to(beTrue())
          expect(parser.getParsedData()).to(beTrue())
          expect(parser.parse("#ENDIF")).to(beTrue())

          expect(parser.getParsedData()).to(beFalse())

          expect(parser.parse("#IF 101")).to(beTrue())
          expect(parser.getParsedData()).to(beTrue())
          expect(parser.parse("#ENDIF")).to(beTrue())

          expect(parser.getParsedData()).to(beFalse())
        }
      }
    }
  }
}
