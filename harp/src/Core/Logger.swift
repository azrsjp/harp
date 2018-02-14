import XCGLogger

struct Logger {
  static private let logIdentifier = "HarpLogger"
  #if DEBUG
  static private let loglevel = XCGLogger.Level.debug
  #else
  static private let loglevel = XCGLogger.Level.error
  #endif

  static private let log = { () -> XCGLogger in
    let log = XCGLogger(identifier: logIdentifier, includeDefaultDestinations: true)
    log.setup(level: loglevel,
              showLogIdentifier: true,
              showFunctionName: true,
              showThreadName: true,
              showLevel: true,
              showFileNames: true,
              showLineNumbers: true,
              showDate: true,
              writeToFile: nil,
              fileLevel: nil)
    return log
  }()
  
  static func verbose(_ closure: @autoclosure @escaping () -> Any?,
                      functionName: StaticString = #function,
                      fileName: StaticString = #file,
                      lineNumber: Int = #line) {
    log.verbose(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
  }
  
  static func debug(_ closure: @autoclosure @escaping () -> Any?,
                    functionName: StaticString = #function,
                    fileName: StaticString = #file,
                    lineNumber: Int = #line) {
    log.debug(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
  }
  
  static func info(_ closure: @autoclosure @escaping () -> Any?,
                   functionName: StaticString = #function,
                   fileName: StaticString = #file,
                   lineNumber: Int = #line) {
    log.info(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
  }
  
  static func warning(_ closure: @autoclosure @escaping () -> Any?,
                      functionName: StaticString = #function,
                      fileName: StaticString = #file,
                      lineNumber: Int = #line) {
    log.warning(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
  }
  
  static func error(_ closure: @autoclosure @escaping () -> Any?,
                    functionName: StaticString = #function,
                    fileName: StaticString = #file,
                    lineNumber: Int = #line) {
    log.error(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
  }

  static func severe(_ closure: @autoclosure @escaping () -> Any?,
                     functionName: StaticString = #function,
                     fileName: StaticString = #file,
                     lineNumber: Int = #line) {
    log.severe(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
  }
}
