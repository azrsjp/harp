import Foundation
import RxSwift

final class BMSModelSystem {
  
  private(set) var notes: BMSNotesState!
  private(set) var tick: BMSTick!
  private(set) var coord: BMSNoteCoordinate!
  private(set) var sound: BMSSound!
  private(set) var judge: BMSJudge!
  
  private(set) var gauge: Double = 20.0
  private(set) var combo: Int = 0
  private(set) var maxCombo: Int = 0
  private(set) var lastJudge: JudgeData?
  private(set) var liftCount = Variable<Double>(0.0)
  private(set) var coverCount = Variable<Double>(0.0)
  private(set) var hiSpeed = Variable<Double>(1.0)
  private(set) var currentBpm: Double = 0.0
  private(set) var score: Int = 0
  private(set) var scoreProgress: Double = 0.0
  
  private(set) var isReady: Bool = false
  private let disposeBag = DisposeBag()
  
  init(gameOptions options: GameOptionData? = nil) {
    guard let options = options else {
      return
    }
    
    hiSpeed.value = options.hiSpeed
    coverCount.value = options.coverCount
    liftCount.value = options.liftCount
  }

  func prepareData(data: BMSData) {
    notes = BMSNotesState(data: data)
    sound = BMSSound(data: data)
    tick = BMSTick(data: data)
    judge = BMSJudge(notes: notes!, tick: tick!)
    coord = BMSNoteCoordinate(data: data, notes: notes!)
    
    judge.observable.subscribe(onNext: {[weak self] in
      self?.onJudged(judge: $0)
    }).addDisposableTo(disposeBag)
    
    liftCount.asObservable().subscribe(onNext: {[weak self] in
      self?.coord.setLiftCount($0)
    }).addDisposableTo(disposeBag)
    
    coverCount.asObservable().subscribe(onNext: {[weak self] in
      self?.coord.setCoverCount($0)
    }).addDisposableTo(disposeBag)
    
    hiSpeed.asObservable().subscribe(onNext: {[weak self] in
      self?.coord.setHiSpeedCount($0)
    }).addDisposableTo(disposeBag)

    isReady = true
  }
  
  var coverHeight: CGFloat {
    return BMSNoteCoordinate.coverHeight(coverCount: coverCount.value)
  }
  
  var liftHeight: CGFloat {
    return BMSNoteCoordinate.liftHeight(liftCount: liftCount.value)
  }
  
  func gameProgress(at elapsedSec: Double) -> Double {
    return min((elapsedSec / duration), 1.0)
  }
  
  var duration: Double {
    guard isReady, let lastNoteTick = notes.all.last?.tick else {
      return 0.0
    }

    return tick.elapsedAt(tick: lastNoteTick)
  }
  
  func addCoverCount(_ value: Double) {
    let validRange = 0.0...(Config.BMS.laneHeightDivideCount - liftCount.value)
    let newValue = coverCount.value + value
    
    if validRange ~= newValue {
      coverCount.value = newValue
    }
  }

  func addLiftCount(_ value: Double) {
    let validRange = 0.0...(Config.BMS.laneHeightDivideCount - coverCount.value)
    let newValue = liftCount.value + value
    
    if validRange ~= newValue {
      liftCount.value = newValue
    }
  }
  
  func addHiSpeedCount(_ value: Double) {
    let validRange = 0.5...6.0
    let newValue = hiSpeed.value + value

    if validRange ~= newValue {
      hiSpeed.value = newValue
    }
  }
  
  func setCurrentBpm(_ bpm: Double) {
    currentBpm = bpm
  }
  
  func getCurrentData() {
  
  }
  
  // MARK: - private
  
  private func onJudged(judge: JudgeData) {
    lastJudge = judge
  }
}
