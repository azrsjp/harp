import Foundation

fileprivate let controlFlowCommandsRANDOM = "RANDOM"
fileprivate let controlFlowCommandsIF = "IF"
fileprivate let controlFlowCommandsENDIF = "ENDIF"

final class BMSControlFlowParser {

  private var randomValue: UInt?
  private var isBreakingBlock = false
  private var isInRandomBlock = false

  // MARK: - inernal

  func parse(_ line: String) -> Bool {
    guard
      let result = line.pregMatche(pattern: "(?<=^#)([A-Z]+)[\\s\t　]*(\\d*)"),
      isValidCommand(command: result[1]) else {
        return false
    }

    consumeControlFlowCommand(command: result[1],
                              value: result[2])

    return true
  }

  // Returns current context status if parser should read block.

  func getParsedData() -> Bool {
    return isBreakingBlock || isInRandomBlock
  }

  // MARK: - private

  private func isValidCommand(command: String) -> Bool {
    let isValid
      = [controlFlowCommandsRANDOM,
        controlFlowCommandsIF,
        controlFlowCommandsENDIF].contains(command)

    return isValid
  }

  private func consumeControlFlowCommand(command: String, value: String) {
    switch command {
    case controlFlowCommandsRANDOM:
      consumeRandomCommand(value)

    case controlFlowCommandsIF:
      consumeIfCommand(value)

    case controlFlowCommandsENDIF:
      consumeIFEndCommand()

    default:
      break
    }
  }
  
  private func consumeRandomCommand(_ value: String) {
    let random = arc4random_uniform(UInt32(value) ?? 0) + 1
    randomValue = UInt(random)
    isInRandomBlock = true
  }
  
  private func consumeIfCommand(_ value: String) {
    guard let currentRandom = randomValue,
      let condition = UInt(value), !isBreakingBlock else {
        isBreakingBlock = true
        isInRandomBlock = false
        return
    }
    
    let shouldBreakBlock = condition != currentRandom
    isBreakingBlock = shouldBreakBlock
    isInRandomBlock = false
  }
  
  private func consumeIFEndCommand() {
    isBreakingBlock = false
    isInRandomBlock = false
  }
}
