import Foundation

final class SoundPlayer<T: Hashable> {
  private var sources: [T: SoundSource]
  
  init(keyAndSources: [T: SoundSource]) {
    sources = keyAndSources
  }

  func play(forKey: T) {
    guard let source = sources[forKey] else {
      return
    }
    
    source.play()
  }
  
  func stop(forKey: T) {
    guard let source = sources[forKey] else {
      return
    }
    
    source.stop()
  }
  
  func pause(forKey: T) {
    guard let source = sources[forKey] else {
      return
    }
    
    source.pause()
  }
  
  func setOffset(second: Float, forKey: T) {
    guard let source = sources[forKey] else {
      return
    }
    
    source.setOffset(second: second)
  }
  
  func setShouldLooping(_ shouldLoop: Bool, forKey: T) {
    guard let source = sources[forKey] else {
      return
    }
    
    source.setShouldLooping(shouldLoop)
  }
  
  func setVolume(_ value: Float, forKey: T) {
    guard let source = sources[forKey] else {
      return
    }
    
    source.setVolume(value)
  }
}
