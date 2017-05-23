import Foundation

final class BMSModelSystem {
  let notes: BMSNotesState
  let tick: BMSTick
  let coord: BMSNoteCoordinate
  let sound: BMSSound
  let judge: BMSJudge
  
  init(data: BMSData) {
    notes = BMSNotesState(data: data)
    sound = BMSSound(data: data)
    tick = BMSTick(data: data)
    judge = BMSJudge(notes: notes, tick: tick)
    coord = BMSNoteCoordinate(data: data, notes: notes)
  }
}
