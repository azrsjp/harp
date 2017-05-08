import Quick
import Nimble
@testable import harp

class BMSHeaderDataParserTest: QuickSpec {
  override func spec() {
    describe("BMSChannelDataParser") {
      describe("#parse") {

        let parser = BMSHeaderParser()

        context("formatted data") {
          it("parse collectly") {
            _ = parser.parse("#PLAYER 1")
            expect(parser.getParsedData().player).to(equal(1))

            _ = parser.parse("#RANK 10")
            expect(parser.getParsedData().rank).to(equal(10))

            _ = parser.parse("#TOTAL 400")
            expect(parser.getParsedData().total).to(equal(400))

            _ = parser.parse("#STAGEFILE stg_file.gif")
            expect(parser.getParsedData().stageFile).to(equal("stg_file.gif"))

            _ = parser.parse("#BANNER banner.jpg")
            expect(parser.getParsedData().banner).to(equal("banner.jpg"))

            _ = parser.parse("#PLAYLEVEL 12")
            expect(parser.getParsedData().playLevel).to(equal(12))

            _ = parser.parse("#DIFFICULTY 4")
            expect(parser.getParsedData().difficulty).to(equal(4))

            _ = parser.parse("#TITLE Music Title Is Here")
            expect(parser.getParsedData().title).to(equal("Music Title Is Here"))

            _ = parser.parse("#SUBTITLE ハウス")
            expect(parser.getParsedData().subTitle).to(equal("ハウス"))

            _ = parser.parse("#ARTIST gomachan_7")
            expect(parser.getParsedData().artist).to(equal("gomachan_7"))

            _ = parser.parse("#SUBARTIST goma boys and girls")
            expect(parser.getParsedData().subArtist).to(equal("goma boys and girls"))

            _ = parser.parse("#GENRE House music")
            expect(parser.getParsedData().genre).to(equal("House music"))

            _ = parser.parse("#BPM 128.52")
            expect(parser.getParsedData().bpm).to(equal(128.52))

            _ = parser.parse("#EXBPM12 60.5")
            expect(parser.getParsedData().exBpm[38]).to(equal(60.5))

            _ = parser.parse("#STOP25 10")
            expect(parser.getParsedData().stop[Int("25", radix: 36)!]).to(equal(10))

            _ = parser.parse("#LNOBJ ZZ")
            expect(parser.getParsedData().lnobj).to(equal(Int("ZZ", radix: 36)!))

            _ = parser.parse("#WAV05 test.wav")
            expect(parser.getParsedData().wav[Int("05", radix: 36)!]).to(equal("test.wav"))

            _ = parser.parse("#BMP0Z test.bmp")
            expect(parser.getParsedData().bmp[Int("0Z", radix: 36)!]).to(equal("test.bmp"))
          }
        }
      }
    }
  }
}
