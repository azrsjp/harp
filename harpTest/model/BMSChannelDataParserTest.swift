import Quick
import Nimble
@testable import harp

class BMSChannelDataParserTest: QuickSpec {
  override func spec() {
    describe("BMSChannelDataParser") {
      describe("#parse") {

        var parser = BMSChannelDataParser()

        beforeEach {
          parser = BMSChannelDataParser()
        }

        it("parse collectly") {
          _ = parser.parse("#16516:001122")
          let bar165ScratchOf1p = parser.getParsedData()[165].notes

          let key1 = BMSNoteTraitData(side: SideType.player1,
                                      lane: LaneType.scratch,
                                      type: NoteType.visible)

          expect(bar165ScratchOf1p[key1]).to(equal("001122"))

          _ = parser.parse("#99942:ZZ00ABAA")
          let bar999InvisibleKey2Of2p = parser.getParsedData()[999].notes

          let key2 = BMSNoteTraitData(side: SideType.player2,
                                      lane: LaneType.key2,
                                      type: NoteType.invisible)

          expect(bar999InvisibleKey2Of2p[key2]).to(equal("ZZ00ABAA"))
        }

        it("merge same note length data(overwrite whote note)") {
          let old = "1111111111"
          let new = "2222222222"

          _ = parser.parse("#00311:\(old)")
          _ = parser.parse("#00311:\(new)")

          let result = parser.getParsedData()[003].notes

          let key = BMSNoteTraitData(side: SideType.player1,
                                     lane: LaneType.key1,
                                     type: NoteType.visible)

          expect(result[key]).to(equal("2222222222"))
        }

        it("merge diff note length data") {
          let old = "1122"
          let new = "5566778899"

          _ = parser.parse("#00311:\(old)")
          _ = parser.parse("#00311:\(new)")

          let result = parser.getParsedData()[003].notes

          let key = BMSNoteTraitData(side: SideType.player1,
                                     lane: LaneType.key1,
                                     type: NoteType.visible)

          expect(result[key]).to(equal("55006600772288009900"))
        }
      }
    }
  }
}
