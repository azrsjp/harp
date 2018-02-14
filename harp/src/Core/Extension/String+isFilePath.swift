import Foundation

extension String {
  func isFilePath() -> Bool {
    let path = URL(fileURLWithPath: self).path
    
    let isExist = FileManager.default.fileExists(atPath: path)
    
    return isExist
  }
  
  func isDirPath() -> Bool {
    let path = URL(fileURLWithPath: self).path
    var isExist: ObjCBool = false

    FileManager.default.fileExists(atPath: path, isDirectory: &isExist)
    
    return isExist.boolValue
  }
  
  func getFileDirPathIfAvailable() -> String? {
    if self.isDirPath() {
      return self
    }
    
    let dirPath = URL(fileURLWithPath: self).deletingLastPathComponent().path

    guard dirPath.isDirPath() else {
      return nil
    }
    
    return dirPath
  }
}
