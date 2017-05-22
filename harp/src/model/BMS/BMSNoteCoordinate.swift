import Foundation

final class BMSNoteCoordinate {

  private var hiSpeed: Double = 4.0
  private var basePixelPerTick: Double
  private var barStartTicks = [Int]()
  private let notes: BMSNotesState

  // MARK: - internal

  init(data: BMSData, notes: BMSNotesState) {
    basePixelPerTick = Config.BMS.defaultBarHeight / Double(Config.BMS.baseBarTick)
    barStartTicks = data.channel.map { $0.startTick }

    self.notes = notes
  }

  // MARK: - internal

  func setHiSpeed(_ hiSpeed: Double) {
    self.hiSpeed = hiSpeed
  }

  func getBarLinesInLaneAt(tick: Int) -> [BMSBarLineCoordData] {
    let tickRange = tickRangeInLane(startTick: tick)

    return barStartTicks
      .filter { tickRange ~= $0 }
      .map { BMSBarLineCoordData(offsetY: CGFloat(self.calcLengthBy(tickCount: $0 - tick))) }
  }

  func getNotesInLaneAt(tick: Int) -> [BMSNoteCoordData] {
    let tickRange = tickRangeInLane(startTick: tick)

    return notes.alive
      .filter { tickRange ~= $0.tick && ($0.trait.type == .visible) }
      .flatMap {
          let noteId = $0.hashValue
          let offsetY = CGFloat(self.calcLengthBy(tickCount: $0.tick - tick))
          let judge = self.notes.judgeOf(note: $0)

          return BMSNoteCoordData(noteId: noteId,
                                  trait: $0.trait,
                                  offsetY: offsetY,
                                  judge: judge)
    }
  }
  
  func getLongNotesInLaneAt(tick: Int) -> [BMSLongNoteCoordData] {
    let tickRange = tickRangeInLane(startTick: tick)

    return notes.longNotesInRange(tickRange)
      .flatMap {(longs: BMSLongNoteState) -> [BMSLongNoteCoordData] in

      let startTick = longs.start.tick > tick ? longs.start.tick : tick
      
      return [BMSLongNoteCoordData(noteId: longs.start.hashValue,
                                      trait: longs.start.trait,
                                      offsetY: CGFloat(self.calcLengthBy(tickCount: startTick - tick)),
                                      judge: self.notes.judgeOf(note: longs.start),
                                      isActive: longs.isActive,
                                      length: CGFloat(calcLengthBy(tickCount: (longs.end.tick - startTick)))),
             BMSLongNoteCoordData(noteId: longs.end.hashValue,
                                  trait: longs.end.trait,
                                  offsetY: CGFloat(self.calcLengthBy(tickCount: longs.end.tick - tick)),
                                  judge: self.notes.judgeOf(note: longs.end),
                                  isActive: false,
                                  length: 0.0)]
    }
  }

  // MARK: - private

  private func calcLengthBy(tickCount: Int) -> Double {
    let length = basePixelPerTick * hiSpeed * Double(tickCount)

    return length
  }
  
  private func tickRangeInLane(startTick: Int) -> ClosedRange<Int> {
    let endTick = Int(Config.BMS.defaultLaneHeight / (basePixelPerTick * hiSpeed))
    
    return startTick...(startTick + endTick)
  }
}
