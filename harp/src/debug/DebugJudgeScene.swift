import Foundation
import SpriteKit

fileprivate var secondsToFall: Double = 1.0

class MyThread: Thread {
  private var start: Date!
  let interval: TimeInterval = 1.0 / 250.0
  
  override func main() {
    start = Date()

    while !isCancelled {
      Thread.sleep(forTimeInterval: interval)
    }
  }
  
  func calcDiff() -> TimeInterval {
    guard let start = start else {
      return 0.0
    }

    let end = Date()
    let interval = end.timeIntervalSince(start)

    return interval
  }
}

class DebugJudgeScene: BasicScene {

  private var height: CGFloat = 0.0
  private var thread = MyThread()
  private let note = SKSpriteNode()
  private let noteTarget = SKSpriteNode()
  
  deinit {
    thread.cancel()
  }

  override func didMove(to view: SKView) {
    super.didMove(to: view)
    
    height = size.height - 100.0
    note.size = CGSize(width: 80.0, height: 10.0)
    note.position = CGPoint(x: 100.0, y: size.height)
    note.color = NSColor.blue
    
    noteTarget.size = CGSize(width: 80.0, height: 10.0)
    noteTarget.position = CGPoint(x: 100.0, y: 100.0)
    noteTarget.color = NSColor.red
    
    addChild(noteTarget)
    addChild(note)
  }

  override func keyDown(with event: NSEvent) {
    if event.keyCode == 7 {
      if !thread.isExecuting {
        thread = MyThread()
        thread.start()
      }
    }
    
    if event.keyCode == 125 {
      secondsToFall -= 2.0
      Logger.debug("speedChanged: \(secondsToFall)")
    }
    
    if event.keyCode == 126 {
      secondsToFall += 2.0
      Logger.debug("speedChanged: \(secondsToFall)")
    }
    
    if event.keyCode == 6 {
      Logger.debug("isExcuting: \(self.thread.isExecuting)")
      Logger.debug("isFinished: \(self.thread.isFinished)")
      Logger.debug("isCancelled: \(self.thread.isCancelled)")

      let interval = thread.calcDiff()
      let diff = secondsToFall - interval
      thread.cancel()
      
      Logger.debug("\(interval), \(secondsToFall), \(diff)")
      
      if abs(diff) < 0.010 {
        Logger.debug(Judge.perfectGreat)
      } else if abs(diff) < 0.020 {
        Logger.debug(Judge.great)
      } else if abs(diff) < 0.050 {
        Logger.debug(Judge.good)
      } else if abs(diff) < 0.075 {
        Logger.debug(Judge.bad)
      } else {
        Logger.debug(Judge.positivePoor)
      }
    }
  }
  
  override func update(_ currentTime: TimeInterval) {
    super.update(currentTime)

    if thread.isExecuting {
      let elapse = thread.calcDiff()
      let progress = CGFloat(elapse / secondsToFall)
      note.position.y = height * (1.0 - progress) + 100.0
    }
  }
}
