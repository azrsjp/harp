import Foundation

final class BMSHeaderParser {

  private var headerData = BMSHeaderData()

  // MARK: - inernal

  func parse(_ line: String) -> Bool {
    return
      tryToParseAsPLAYER(line) ||
      tryToParseAsRANK(line) ||
      tryToParseAsTOTAL(line) ||
      tryToParseAsSTAGEFILE(line) ||
      tryToParseAsBANNER(line) ||
      tryToParseAsPLAYLEVEL(line) ||
      tryToParseAsDIFFICULTY(line) ||
      tryToParseAsTITLE(line) ||
      tryToParseAsSUBTITLE(line) ||
      tryToParseAsARTIST(line) ||
      tryToParseAsSUBARTIST(line) ||
      tryToParseAsGENRE(line) ||
      tryToParseAsBPM(line) ||
      tryToParseAsEXBPM(line) ||
      tryToParseAsSTOP(line) ||
      tryToParseAsLNOBJ(line) ||
      tryToParseAsWAV(line) ||
      tryToParseAsBMP(line)
  }

  func getParsedData() -> BMSHeaderData {
    return headerData
  }

  // MARK: - private

  private func tryToParseAsPLAYER(_ line: String) -> Bool {
    guard let player = line.pregMatche(pattern: "(?i)^#PLAYER[\\s\\t　]+(\\d)") else {
      return false
    }

    headerData.player ?= Int(player[1])
    return true
  }

  private func tryToParseAsRANK(_ line: String) -> Bool {
    guard let rank = line.pregMatche(pattern: "(?i)^#RANK[\\s\\t　]+(\\d+)") else {
      return false
    }

    headerData.rank ?= Int(rank[1])
    return true
  }

  private func tryToParseAsTOTAL(_ line: String) -> Bool {
    guard let total = line.pregMatche(pattern: "(?i)^#TOTAL[\\s\\t　]+(\\d+)") else {
      return false
    }

    headerData.total ?= Int(total[1])
    return true
  }

  private func tryToParseAsSTAGEFILE(_ line: String) -> Bool {
    guard let stageFile = line.pregMatche(pattern: "(?i)^#STAGEFILE[\\s\\t　]+([^\\s\\t　].*)") else {
      return false
    }

    headerData.stageFile = stageFile[1]
    return true
  }

  private func tryToParseAsBANNER(_ line: String) -> Bool {
    guard let banner = line.pregMatche(pattern: "(?i)^#BANNER[\\s\\t　]+([^\\s\\t　].*)") else {
      return false
    }

    headerData.banner = banner[1]
    return true
  }

  private func tryToParseAsPLAYLEVEL(_ line: String) -> Bool {
    guard let playLevel = line.pregMatche(pattern: "(?i)^#PLAYLEVEL[\\s\\t　]+(\\d+)") else {
      return false
    }

    headerData.playLevel ?= Int(playLevel[1])
    return true
  }

  private func tryToParseAsDIFFICULTY(_ line: String) -> Bool {
    guard let difficulty = line.pregMatche(pattern: "(?i)^#DIFFICULTY[\\s\\t　]+(\\d)") else {
      return false
    }

    headerData.difficulty ?= Int(difficulty[1])
    return true
  }

  private func tryToParseAsTITLE(_ line: String) -> Bool {
    guard let title = line.pregMatche(pattern: "(?i)^#TITLE[\\s\\t　]+([^\\s\\t　].*)") else {
      return false
    }

    headerData.title = title[1]
    return true
  }

  private func tryToParseAsSUBTITLE(_ line: String) -> Bool {
    guard let subTitle = line.pregMatche(pattern: "(?i)^#SUBTITLE[\\s\\t　]+([^\\s\\t　].*)") else {
      return false
    }

    headerData.subTitle = subTitle[1]
    return true
  }

  private func tryToParseAsARTIST(_ line: String) -> Bool {
    guard let artist = line.pregMatche(pattern: "(?i)^#ARTIST[\\s\\t　]+([^\\s\\t　].*)") else {
      return false
    }

    headerData.artist = artist[1]
    return true
  }

  private func tryToParseAsSUBARTIST(_ line: String) -> Bool {
    guard let subArtist = line.pregMatche(pattern: "(?i)^#SUBARTIST[\\s\\t　]+([^\\s\\t　].*)") else {
      return false
    }

    headerData.subArtist = subArtist[1]
    return true
  }

  private func tryToParseAsGENRE(_ line: String) -> Bool {
    guard let genre = line.pregMatche(pattern: "(?i)^#GENRE[\\s\\t　]+([^\\s\\t　].*)") else {
      return false
    }

    headerData.genre = genre[1]
    return true
  }

  private func tryToParseAsBPM(_ line: String) -> Bool {
    guard let bpm = line.pregMatche(pattern: "(?i)^#BPM[\\s\\t　]+([0-9][0-9.]*)") else {
      return false
    }

    headerData.bpm ?= Double(bpm[1])
    return true
  }

  private func tryToParseAsEXBPM(_ line: String) -> Bool {
    guard let exBpm = line.pregMatche(pattern: "(?i)^#(BPM|EXBPM)([0-9A-Z]{2})[\\s\\t　]+([0-9][0-9.]*)"),
      let index = Int(exBpm[2], radix: 36) else {
        return false
    }

    headerData.exBpm[index] ?= Double(exBpm[3])
    return true
  }

  private func tryToParseAsSTOP(_ line: String) -> Bool {
    guard let stop = line.pregMatche(pattern: "(?i)^#STOP([0-9A-Z]{2})[\\s\\t　]+(\\d+)"),
      let index = Int(stop[1], radix: 36) else {
        return false
    }

    headerData.stop[index] ?= Int(stop[2])
    return true
  }

  private func tryToParseAsLNOBJ(_ line: String) -> Bool {
    guard let lnobj = line.pregMatche(pattern: "(?i)^#LNOBJ[\\s\\t　]+([0-9A-Z]{2})"),
      let index = UInt(lnobj[1], radix: 36) else {
        return false
    }

    headerData.lnobj ?= Int(index)
    return true
  }

  private func tryToParseAsWAV(_ line: String) -> Bool {
    guard let wav = line.pregMatche(pattern: "(?i)^#WAV([0-9A-Z]{2})[\\s\\t　]+([^\\s\\t　].*)"),
      let index = Int(wav[1], radix: 36) else {
        return false
    }

    headerData.wav[index] = wav[2]
    return true
  }

  private func tryToParseAsBMP(_ line: String) -> Bool {
    guard let bmp = line.pregMatche(pattern: "(?i)^#BMP([0-9A-Z]{2})[\\s\\t　]+([^\\s\\t　].*)"),
      let index = Int(bmp[1], radix: 36) else {
        return false
    }

    headerData.bmp[index] = bmp[2]
    return true
  }
}
