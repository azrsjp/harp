import Foundation

extension String {
  init?(unknownEncodingContentsOfFile: String) {
    guard FileManager.default.fileExists(atPath: unknownEncodingContentsOfFile) else {
      Logger.error("BMS file is not exist. Full file path is: \(unknownEncodingContentsOfFile)")
      
      return nil
    }
    
    guard let fileData = NSData(contentsOfFile: unknownEncodingContentsOfFile) else {
      return nil
    }
    
    do {
      let fileEncoding = DMJudgeTextEncodingOfData(rawData: fileData)

      try self.init(contentsOfFile: unknownEncodingContentsOfFile, encoding: fileEncoding)
    } catch let e as NSError {
      Logger.error(e)
      
      return nil
    }
  }
}
