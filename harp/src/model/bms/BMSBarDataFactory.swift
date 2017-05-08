import Foundation

final class BMSBarDataFactory {

  // MARK: - internal

  static func makeFrom(headerData: BMSHeaderData,
                       channelData: [BMSChannelData]) -> [BMSBarData] {

    let barLength = channelData.count
    var barData = [BMSBarData](repeating: BMSBarData(), count: barLength)

    var currentTick = 0

    for bar in 0..<barLength {
      let barTickCount
        = Int(Double(Config.BMS.baseBarTick) * (channelData[bar].changeScale ?? 1.0))

      barData[bar].barScale ?= channelData[bar].changeScale
      barData[bar].startTick = currentTick
      barData[bar].barTickCount = barTickCount

      channelData[bar].playWav.forEach {
        storeEventData(to: &(barData[bar].playWav),
                       baseTick: currentTick,
                       barTickCount: barTickCount,
                       data: $0,
                       maker: { BMSBarEventData(tick: $0, key: $1) })
      }

      storeChangeBpmData(to: &(barData[bar].changeExBpm),
                         baseTick: currentTick,
                         barTickCount: barTickCount,
                         data: channelData[bar].changeBpm)

      storeEventData(to: &(barData[bar].changeBaseLayer),
                     baseTick: currentTick,
                     barTickCount: barTickCount,
                     data: channelData[bar].changeBaseLayer,
                     maker: { BMSBarEventData(tick: $0, key: $1) })

      storeEventData(to: &(barData[bar].changePoorLayer),
                     baseTick: currentTick,
                     barTickCount: barTickCount,
                     data: channelData[bar].changePoorLayer,
                     maker: { BMSBarEventData(tick: $0, key: $1) })

      storeChangeExBpmData(to: &(barData[bar].changeExBpm),
                           header: headerData,
                           baseTick: currentTick,
                           barTickCount: barTickCount,
                           data: channelData[bar].changeExBpm)

      storeEventData(to: &(barData[bar].stopPlay),
                     baseTick: currentTick,
                     barTickCount: barTickCount,
                     data: channelData[bar].stopPlay,
                     maker: { BMSBarEventData(tick: $0, key: $1) })

      channelData[bar].notes.forEach { k, v in
        storeEventData(to: &(barData[bar].notes),
                       baseTick: currentTick,
                       barTickCount: barTickCount,
                       data: v,
                       maker: { BMSBarNoteData(tick: $0, key: $1,
                                               trait: k) })
      }

      // Means next startTick
      currentTick += barTickCount
    }

    sortBarDataOrderByTickAsc(&barData)

    return barData
  }

  // MARK: - private

  static private func sortBarDataOrderByTickAsc(_ barData: inout [BMSBarData]) {

    for (i, v) in barData.enumerated() {
      barData[i].notes = v.notes.sorted { $0.0.tick < $0.1.tick }
      barData[i].playWav = v.playWav.sorted { $0.0.tick < $0.1.tick }
      barData[i].changeExBpm = v.changeExBpm.sorted { $0.0.tick < $0.1.tick }
      barData[i].changeBaseLayer = v.changeBaseLayer.sorted { $0.0.tick < $0.1.tick }
      barData[i].changePoorLayer = v.changePoorLayer.sorted { $0.0.tick < $0.1.tick }
      barData[i].stopPlay = v.stopPlay.sorted { $0.0.tick < $0.1.tick }
    }
  }

  static private func storeChangeBpmData(to target: inout [BMSBarBPMEventData],
                                         baseTick: Int, barTickCount: Int, data: String?) {
    guard
      let data = data,
      let dataArray = data.splitBy(length: 2) else {
        return
    }

    let dataLength = dataArray.count

    dataArray.enumerated().forEach { i, v in
      guard
      v != Config.BMS.keyForRest,
        let intBpm = Int(v, radix: 16) else {
          return
      }

      let posInBar = Double(i) / Double(dataLength)
      let tick = baseTick + Int(Double(barTickCount) * posInBar)

      let bpm = Double(intBpm)

      // Overrwite if exist on same tick already
      if let index = target.index(where: { $0.tick == tick }) {
        target[index].value = bpm
      } else {
        target.append(BMSBarBPMEventData(tick: tick, value: bpm))
      }
    }
  }

  static private func storeChangeExBpmData(to target: inout [BMSBarBPMEventData],
                                           header: BMSHeaderData,
                                           baseTick: Int, barTickCount: Int, data: String?) {
    guard
      let data = data,
      let dataArray = data.splitBy(length: 2) else {
        return
    }

    let dataLength = dataArray.count

    dataArray.enumerated().forEach { i, v in
      guard
      v != Config.BMS.keyForRest,
        let key = Int(v, radix: 36),
        let bpm = header.exBpm[key] else {
          return
      }

      let posInBar = Double(i) / Double(dataLength)
      let tick = baseTick + Int(Double(barTickCount) * posInBar)

      // Overrwite if exist on same tick already
      if let index = target.index(where: { $0.tick == tick }) {
        target[index].value = bpm
      } else {
        target.append(BMSBarBPMEventData(tick: tick, value: bpm))
      }
    }
  }

  static private func storeEventData<T>(to target: inout [T],
                                        baseTick: Int, barTickCount: Int, data: String?,
                                        maker: (_ tick: Int, _ key: Int) -> T) {
    guard
      let data = data,
      let dataArray = data.splitBy(length: 2) else {
        return
    }

    let dataLength = dataArray.count
    let keyForRest = Int(Config.BMS.keyForRest, radix: 36)!

    dataArray.enumerated().forEach { i, v in
      let posInBar = Double(i) / Double(dataLength)
      let tick = baseTick + Int(Double(barTickCount) * posInBar)

      guard let key = Int(v, radix: 36),
        key != keyForRest else {
          return
      }

      target.append(maker(tick, key))
    }
  }
}
