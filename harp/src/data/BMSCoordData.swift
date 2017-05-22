import Foundation

struct BMSCoordData {
  let judge: String
  let combo: Int

  let notes: [BMSNoteCoordData]
  let longNotes: [BMSLongNoteCoordData]
  let barLines: [BMSBarLineCoordData]
}

protocol BMSBasicNoteCoord {
  var noteId: Int { get set }
  var trait: BMSNoteTraitData { get set }
  var offsetY: CGFloat { get set }
  var judge: Judge { get set }
}

struct BMSNoteCoordData: BMSBasicNoteCoord {
  var noteId: Int
  var trait: BMSNoteTraitData
  var offsetY: CGFloat
  var judge: Judge
}

struct BMSLongNoteCoordData: BMSBasicNoteCoord {
  var noteId: Int
  var trait: BMSNoteTraitData
  var offsetY: CGFloat
  var judge: Judge

  // LongNote feature
  var isActive: Bool
  var length: CGFloat
}

struct BMSBarLineCoordData {
  var offsetY: CGFloat
}
