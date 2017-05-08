import Foundation
import RxSwift

final class BMSParser {

  // MARK: - inernal

  static func parse(contentsOfBMS: String) -> Observable<BMSData> {
    return Observable.create { observer in
      
      let parsedData = BMSParser.internalParse(contentsOfBMS)
      
      observer.onNext(parsedData)
      
      return Disposables.create()
    }
  }

  // MARK: - private

  static private func internalParse(_ contentsOfBMS: String) -> BMSData {

    let controlFlowParser = BMSControlFlowParser()
    let headerParser = BMSHeaderParser()
    let channelDataParser = BMSChannelDataParser()

    // Try to parse with priority [content flow] -> [channel data] -> [header] by a line.
    // If parse succeed, proceed to next line immediately.

    contentsOfBMS.enumerateLines { line, _ in
      let trimmed = line.trim()

      // Skip parsing in breaking block mode or
      // in random block (ready to evaluate "#IF n").
      if controlFlowParser.parse(trimmed) ||
        controlFlowParser.getParsedData() {
        return
      }

      if channelDataParser.parse(trimmed) {
        return
      }

      if headerParser.parse(trimmed) {
        return
      }
    }
  
    let bmsData = BMSData()
    bmsData.header = headerParser.getParsedData()
    bmsData.channel = channelDataParser.getParsedData()
    bmsData.bars = BMSBarDataFactory.makeFrom(headerData: bmsData.header,
                                              channelData: bmsData.channel)

    return bmsData
  }
}
