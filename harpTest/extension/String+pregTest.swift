import Quick
import Nimble
@testable import harp

class StringPregTest: QuickSpec {
  override func spec() {
    describe("String") {
      describe("trim") {
        context(" hello azarashi　world　\n 　　") {
          let string = " hello azarashi　world　\n 　　"

          it("前後のスペースがトリムされて'hello azarashi　world'になる") {
            let result = string.trim()
            expect(result).to(equal("hello azarashi　world"))
          }
        }
      }

      describe("pergMatch") {
        context("🍣 is good, tasty. 🍣 = 🐟 + 🍚. マルチバイト文字列のサンプル。") {
          let string = "🍣 is good, tasty. 🍣 = 🐟 + 🍚. マルチバイト文字列のサンプル。"

          it("🍣がマッチする") {
            let result = string.pregMatche(pattern: "🍣")
            expect(result).to(beTrue())
          }

          it("🐈はマッチしない") {
            let result = string.pregMatche(pattern: "🐈")
            expect(result).to(beFalse())
          }

          it("'マルチバイト文字列'はマッチする") {
            let result = string.pregMatche(pattern: "マルチバイト文字列")
            expect(result).to(beTrue())
          }

          it("'good'はマッチする") {
            let result = string.pregMatche(pattern: "good")
            expect(result).to(beTrue())
          }

          it("'g*d'はマッチする") {
            let result = string.pregMatche(pattern: "g*d")
            expect(result).to(beTrue())
          }

          it("'マルチバイト...'がマッチして'マルチバイト文字列'を取得") {
            var matches = [String]()
            let result = string.pregMatche(pattern: "マルチバイト...", matches: &matches)
            expect(result).to(beTrue())
            expect(matches.first!).to(equal("マルチバイト文字列"))
          }
        }

        context("#TITLE タイトル #BPM 499 ああああ") {
          let string = "#TITLE タイトル #BPM 499 ああああ"

          it("'#TITLE 'から始まっている") {
            let result = string.pregMatche(pattern: "^#TITLE ")
            expect(result).to(beTrue())
          }

          it("'#BPM 'から始まっていない") {
            let result = string.pregMatche(pattern: "^#BPM ")
            expect(result).to(beFalse())
          }

          it("全後方先読みを使って'TITLE'を抽出する") {
            var matches = [String]()
            let result = string.pregMatche(pattern: "(?<=^#)[a-zA-Z0-9]*(?=(\\s|　))", matches: &matches)
            expect(result).to(beTrue())
            expect(matches.first!).to(equal("TITLE"))
          }
        }
      }
    }

    describe("pergReplace") {
      context("#TITLE タイトル文字🍣") {
        let string = "#TITLE タイトル文字🍣"

        it("'#TITLE 'を''で置き換える") {
          let result = string.pregReplace(pattern: "#TITLE ", with: "")
          expect(result).to(equal("タイトル文字🍣"))
        }
      }

      context("#TITLE タイトル文字🍣") {
        let string = "#TITLE タイトル文字🍣"

        it("'#TITLE 'を''で置き換える") {
          let result = string.pregReplace(pattern: "#TITLE ", with: "")
          expect(result).to(equal("タイトル文字🍣"))
        }
      }

      context("🍛 = 🐟 + 🍚") {
        let string = "🍛 = 🐟 + 🍚"

        it("'🍛'を'🍣'で置き換える") {
          let result = string.pregReplace(pattern: "🍛", with: "🍣")
          expect(result).to(equal("🍣 = 🐟 + 🍚"))
        }
      }
    }
  }
}
