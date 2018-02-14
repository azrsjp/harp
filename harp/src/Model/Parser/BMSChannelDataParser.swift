import Foundation

final class BMSChannelDataParser {

  private var channelData = [BMSChannelData]()

  // MARK: - inernal

  func parse(_ line: String) -> Bool {

    let channelPattern = "(?i)^#(\\d{3})(\\d{2}):(([0-9A-Z]{2}|[0-9.]+|\\s|\\t|　)+)"

    guard let parsed = line.pregMatche(pattern: channelPattern) else {
      return false
    }

    let bar = Int(parsed[1]) ?? 0
    let channel = Int(parsed[2]) ?? 0
    let body = parsed[3].pregReplace(pattern: "(\\s|\\t|　)", with: "") // Remove spaces.

    return addData(bar: bar, channel: channel, body: body)
  }

  func getParsedData() -> [BMSChannelData] {
    calcTick()

    return channelData
  }

  // MARK: - private

  private func addData(bar: Int, channel: Int, body: String) -> Bool {

    addChannelDataByBarIfNeeded(bar)

    switch channel {
    case 1: return addPlayWavData(bar, body)
    case 2: return addChangeBarScaleData(bar, body)
    case 3: return addNoteFeaturedData(body, &(channelData[bar].changeBpm))
    case 4: return addNoteFeaturedData(body, &(channelData[bar].changeBaseLayer))
    case 6: return addNoteFeaturedData(body, &(channelData[bar].changePoorLayer))
    case 8: return addNoteFeaturedData(body, &(channelData[bar].changeExBpm))
    case 9: return addNoteFeaturedData(body, &(channelData[bar].stopPlay))
    case 11...69: return addNoteData(channel, body, &(channelData[bar].notes))
    default: break
    }

    return false
  }

  private func addChannelDataByBarIfNeeded(_ bar: Int) {
    guard channelData.count <= bar else {
      return
    }

    // Add shortage data space.
    // Bar is 1-origin,so channel by bar array needs bar num plus one space(for easy array access)
    let shortageDataCount = bar - channelData.count + 1
    let dataToAdd = [BMSChannelData](repeating: BMSChannelData(), count: shortageDataCount)

    channelData.append(contentsOf: dataToAdd)
  }

  // Note featured data's char-series array and its index have temporal(time-series) mean,
  // it is, bar division num and each note position in bar.
  // So needs special operation.

  private func addNoteData(_ channel: Int, _ body: String, _ data: inout [BMSNoteTraitData: String]) -> Bool {
    // Determine lane type by channel number.
    guard
      let side = SideType(channel: channel),
      let lane = LaneType(channel: channel),
      let type = NoteType(channel: channel) else {
        return false
    }

    let noteTrait = BMSNoteTraitData(side: side, lane: lane, type: type)

    return addNoteFeaturedData(body, &data[noteTrait])
  }

  private func addNoteFeaturedData(_ body: String, _ data: inout String?) -> Bool {
    data = mergeNoteFeaturedDataBody(old: data, new: body)

    return true
  }

  // Playing wav command is note featured,
  // but do not merge(do not overwritten) data to play multiple sounds at same timing.
  // Push raw data simply.

  private func addPlayWavData(_ bar: Int, _ body: String) -> Bool {
    guard body != Config.BMS.keyForRest else {
      return false
    }

    channelData[bar].playWav.append(body)

    return true
  }

  // Bar scale body data can be single float value.

  private func addChangeBarScaleData(_ bar: Int, _ body: String) -> Bool {
    guard
    bar < channelData.count,
      let scale = Double(body) else {
        return false
    }

    channelData[bar].barScale = scale

    return true
  }

  // Merge note featured channel body.
  // ex) old "1122", new: "5566778899" -> merged: "55006600772288009900"
  // old:    11             22
  // new:    55    66    77    88    99
  // merged: 55 00 66 00 77 22 88 00 99 00

  private func mergeNoteFeaturedDataBody(old: String?, new: String) -> String {
    guard
      let old = old,
      let newDataArray = new.splitBy(length: 2),
      let oldDataArray = old.splitBy(length: 2) else {
        return new
    }

    let lcm = Math.lcm(newDataArray.count, oldDataArray.count)
    let oldInterval = lcm / oldDataArray.count
    let newInterval = lcm / newDataArray.count

    var merged = [String](repeating: Config.BMS.keyForRest, count: lcm)

    merged.enumerated().forEach { i, _ in
      // Allows overwrite
      if i % oldInterval == 0 {
        merged[i] = oldDataArray[i / oldInterval]
      }
      if i % newInterval == 0 {
        merged[i] = newDataArray[i / newInterval]
      }
    }

    return merged.joined()
  }
  
  // Calculate each bar's start timing and length.
  
  private func calcTick() {

    let barLength = channelData.count
    var currentTick = 0

    for bar in 0..<barLength {
      let barTickCount
        = Int(Double(Config.BMS.baseBarTick) * channelData[bar].barScale)
      
      channelData[bar].startTick = currentTick
      channelData[bar].barTickCount = barTickCount

      // Means next startTick
      currentTick += barTickCount
    }
  }
}
