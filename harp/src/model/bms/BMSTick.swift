import Foundation

fileprivate struct BMSBpmChangeTimingData {
  var elapsedAt: Double
  var tick: Int
  var bpm: Double
}

final class BMSTick {

  private var bpmChangeTimings = [BMSBpmChangeTimingData(elapsedAt: 0.0, tick: 0, bpm: 128.0)]

  // MARK: - internal

  init(data: BMSData) {

    // Sort data by elapsedAt desc to easy data finding
    bpmChangeTimings = calculateTimingFrom(data)
      .sorted { $0.0.elapsedAt > $0.1.elapsedAt }
  }

  func tickAt(elapsedSec: Double) -> Int {

    guard elapsedSec > 0,
      let previousBpmChange = getPreviousBpmChangeDataFrom(elapsedSec) else {
        return 0
    }

    // Memo: tick = (elapsed * (bpm / 60.0) * resolution)
    let tickFromLastBpmChanged
      = Int((elapsedSec - previousBpmChange.elapsedAt) * (previousBpmChange.bpm / 60.0) * Double(Config.BMS.resolution))

    return previousBpmChange.tick + tickFromLastBpmChanged
  }

  // MARK: - private

  private func getPreviousBpmChangeDataFrom(_ elapsedSec: Double) -> BMSBpmChangeTimingData? {
    return bpmChangeTimings.first(where: { elapsedSec >= $0.elapsedAt })
  }

  private func calculateTimingFrom(_ data: BMSData) -> [BMSBpmChangeTimingData] {

    var result = [BMSBpmChangeTimingData(elapsedAt: 0.0, tick: 0, bpm: data.header.bpm)]

    data.bars
      .filter { $0.changeExBpm.count > 0 || $0.stopPlay.count > 0 }
      .forEach { barEvents in

        let mergedAndSorted
          = mergeChangeBpmAndStopPlay(changeExBpm: barEvents.changeExBpm,
                                      stopPlay: barEvents.stopPlay)
          .sorted { $0.0.tick < $0.1.tick }

        mergedAndSorted.forEach {
          if let changeBpm = $0 as? BMSBarBPMEventData {
            let timingData = makeDataFrom(changeBpm: changeBpm,
                                          previous: result.last!)
            result.append(timingData)
          }
          if let stop = $0 as? BMSBarEventData {
            guard let stopLength = data.header.stop[stop.key] else {
              return
            }

            let timingDataArray = makeDataFrom(stopAtTick: stop.tick,
                                               stopLength: stopLength,
                                               previous: result.last!)
            result.append(contentsOf: timingDataArray)
          }
        }
    }

    return result
  }

  private func mergeChangeBpmAndStopPlay(changeExBpm: [BMSTimeSeries],
                                         stopPlay: [BMSTimeSeries]) -> [BMSTimeSeries] {
    var mergedArray = [BMSTimeSeries]()
    mergedArray.append(contentsOf: changeExBpm)
    mergedArray.append(contentsOf: stopPlay)

    return mergedArray
  }

  private func makeDataFrom(changeBpm: BMSBarBPMEventData,
                            previous: BMSBpmChangeTimingData) -> BMSBpmChangeTimingData {
    let elapsedFromPrevious = calcDuration(tick: changeBpm.tick - previous.tick, bpm: previous.bpm)
    let elapsedFromStart = previous.elapsedAt + elapsedFromPrevious

    return BMSBpmChangeTimingData(elapsedAt: elapsedFromStart,
                                  tick: changeBpm.tick,
                                  bpm: changeBpm.value)
  }

  private func makeDataFrom(stopAtTick: Int,
                            stopLength: Int,
                            previous: BMSBpmChangeTimingData) -> [BMSBpmChangeTimingData] {

    let elapsedFromPrevious = calcDuration(tick: stopAtTick - previous.tick, bpm: previous.bpm)
    let elapsedFromStart = previous.elapsedAt + elapsedFromPrevious

    let stopStart = BMSBpmChangeTimingData(elapsedAt: elapsedFromStart,
                                           tick: stopAtTick,
                                           bpm: 0.0) // stop is equal to bpm zero

    let elapsedAtBreakStopping = elapsedFromStart + calcStopDuration(stopLength, bpm: previous.bpm)

    let stopEnd = BMSBpmChangeTimingData(elapsedAt: elapsedAtBreakStopping,
                                         tick: stopAtTick, // In stopping, tick does not proceed
                                         bpm: previous.bpm) // Restore bpm to break stopping

    return [stopStart, stopEnd]
  }

  private func calcDuration(tick: Int, bpm: Double) -> Double {
    let beatNum = Double(tick) / Double(Config.BMS.resolution)

    return beatDuration(bpm: bpm) * beatNum
  }

  private func calcStopDuration(_ stopValue: Int, bpm: Double) -> Double {

    // 192 is resolution of 1bar on bms's stop specification and int stop value follows the rule.
    // ex) stop value is 96, stop with duration equivalent to 1/2bar.
    // Note: Stop value is independent of bar scale, always based on 4/4 bar.
    let stopBeatNum = (Double(stopValue) / 192.0) * 4.0

    return beatDuration(bpm: bpm) * stopBeatNum
  }

  private func beatDuration(bpm: Double) -> Double {
    guard bpm > 0 else {
      return 0
    }

    return 60.0 / bpm
  }
}
