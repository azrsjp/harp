import Quick
import Nimble
@testable import harp

class StringSplitmTest: QuickSpec {
  override func spec() {
    describe("String") {
      describe("#split") {
        context("even length string") {
          let string = "0123456789"
          
          it("split by 2-length chars") {
            let result = string.splitBy(length: 2)
            
            expect(result?.count).to(equal(5))
            expect(result?[0]).to(equal("01"))
            expect(result?[2]).to(equal("45"))
            expect(result?[4]).to(equal("89"))
          }
        }
        
        context("odd length string") {
          let string = "abcde"
          
          it("split by 2-length chars") {
            let result = string.splitBy(length: 2)
            
            expect(result?.count).to(equal(3))
            expect(result?[0]).to(equal("ab"))
            expect(result?[1]).to(equal("cd"))
            expect(result?[2]).to(equal("e"))
          }
        }
        
        context("multi byte string") {
          let string = "魚は🐟です。🐡は魚ではありません。"
          
          it("split by 3-length chars") {
            let result = string.splitBy(length: 3)
            
            expect(result?.count).to(equal(6))
            expect(result?[0]).to(equal("魚は🐟"))
            expect(result?[1]).to(equal("です。"))
            expect(result?[2]).to(equal("🐡は魚"))
          }
        }
      }
    }
  }
}
