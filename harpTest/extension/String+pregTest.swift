import Quick
import Nimble
@testable import harp

class StringPregTest: QuickSpec {
  override func spec() {
    describe("String") {
      describe("#pergMatch") {
        context("has multi-byte characters") {
          let string = "🍣 is good+, tasty. 🍣 = 🐟 + 🍚. マルチバイト文字列のサンプル。"

          it("matches used emoji") {
            let result = string.pregMatche(pattern: "🍣")
            let hasMatches = result.count > 0
            expect(hasMatches).to(beTrue())
          }

          it("not matches unused emoji") {
            let result = string.pregMatche(pattern: "🐈")
            let hasMatches = result.count > 0
            expect(hasMatches).to(beFalse())
          }

          it("matches multi-byte string") {
            let result = string.pregMatche(pattern: "マルチバイト文字列")
            let hasMatches = result.count > 0
            expect(hasMatches).to(beTrue())
          }

          it("matches ascii characters") {
            let result = string.pregMatche(pattern: "good+")
            let hasMatches = result.count > 0
            expect(hasMatches).to(beTrue())
          }

          it("matches wild card pattern") {
            let result = string.pregMatche(pattern: "g*d")
            let hasMatches = result.count > 0
            expect(hasMatches).to(beTrue())
          }

          it("matches wild card pattern and take results") {
            let result = string.pregMatche(pattern: "マルチバイト...")
            let hasMatches = result.count > 0
            expect(hasMatches).to(beTrue())
            expect(result.first!).to(equal("マルチバイト文字列"))
          }

          it("matches using lookahead and lookbehind pattern") {
            let result = string.pregMatche(pattern: "(?<=\\s)[a-zA-Z0-9]+(?=\\+,)")
            let hasMatches = result.count > 0
            expect(hasMatches).to(beTrue())
            expect(result[0]).to(equal("good"))
          }

          it("matches group") {
            let result = string.pregMatche(pattern: "(is)\\s(good)\\+,\\s(tasty)")
            expect(result.count).to(equal(4))
            expect(result[1]).to(equal("is"))
            expect(result[2]).to(equal("good"))
            expect(result[3]).to(equal("tasty"))
          }

          it("matches multiple with group") {
            let testString = "bbbbbb"
            let result = testString.pregMatche(pattern: "(bb)(b)")
            expect(result.count).to(equal(6))
            expect(result[0]).to(equal("bbb"))
            expect(result[1]).to(equal("bb"))
            expect(result[2]).to(equal("b"))
            expect(result[3]).to(equal("bbb"))
            expect(result[4]).to(equal("bb"))
            expect(result[5]).to(equal("b"))
          }
        }
      }
    }

    describe("pergReplace") {
      context("has multi-byte characters") {
        let string = "#TITLE タイトル文字🍣"

        it("replace ascii characters") {
          let result = string.pregReplace(pattern: "#TITLE ", with: "")
          expect(result).to(equal("タイトル文字🍣"))
        }

        it("replace multi-byte characters") {
          let result = string.pregReplace(pattern: "🍣", with: "🐟")
          expect(result).to(equal("#TITLE タイトル文字🐟"))
        }
      }
    }
  }
}
