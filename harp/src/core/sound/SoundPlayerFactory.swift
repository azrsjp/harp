import Foundation
import OpenAL

fileprivate let alTrue: ALboolean = Int8(AL_TRUE)
fileprivate let alFalse: ALboolean = Int8(AL_FALSE)
fileprivate let alNone: ALuint = ALuint(AL_NONE)

final class SoundPlayerFactory {
  
  private var cache = [String: SoundPlayer]()

  // This class is Singleton
  // If shared object is nil, try to instantiate because of failable initializer.
  
  static private var instance = SoundPlayerFactory()

  static var shared: SoundPlayerFactory? {
    if instance == nil {
      instance = SoundPlayerFactory()
    }

    return instance
  }

  private init?() {
    let isInitialized = alureInitDevice(nil, nil)

    guard isInitialized == alTrue else {
      Logger.error("Failed to init device")
      return nil
    }
  }

  deinit {
    alureShutdownDevice()
  }
  
  // MARK: - internal
  
  func makePlayer(fullFilePath: String, shouldCache: Bool = false) -> SoundPlayer? {
    if let player = cache[fullFilePath] {
      return player
    }

    guard let player = HarpSoundPlayer(fullFilePath: fullFilePath) else {
      return nil
    }
    
    if shouldCache {
      cache[fullFilePath] = player
    }
    
    return player
  }
  
  func clearCache(fullFilePath: String) {
    cache.removeValue(forKey: fullFilePath)
  }
  
  func clearAllCache() {
    cache.removeAll()
  }
}

// MARK: - fileprivate

fileprivate final class HarpSoundPlayer: SoundPlayer {
  
  private var buffer: ALuint
  private var source: ALuint
  private let fullFilePath: String
  
  init?(fullFilePath: String) {
    let buffer = alureCreateBufferFromFile(fullFilePath)
    
    if buffer == alNone {
      Logger.error("Failed to load \(fullFilePath)")
      return nil
    }
    
    var source: ALuint = 0
    alGenSources(1, &source)
    
    alSourcei(source, AL_BUFFER, ALint(buffer))
    
    self.buffer = buffer
    self.source = source
    self.fullFilePath = fullFilePath
  }

  deinit {
    alureStopSource(source, alTrue)
    alDeleteSources(1, &source)
    alDeleteBuffers(1, &buffer)
  }
  
  // MARK: - SoundPlayer
  
  func play() {
    if alurePlaySource(source, nil, nil) != alTrue {
      Logger.info("Failed to play source \(self.fullFilePath)")
    }
  }

  func stop() {
    if alureStopSource(source, alFalse) != alTrue {
      Logger.info("Failed to stop source \(self.fullFilePath)")
    }
  }

  func pause() {
    if alurePauseSource(source) != alTrue {
      Logger.info("Failed to pause source \(self.fullFilePath)")
    }
  }

  func setOffset(second: Float) {
    alSourcef(source, AL_SEC_OFFSET, second)
  }
  
  func setShouldLooping(_ shouldLoop: Bool) {
    alSourcei(source, AL_LOOPING, shouldLoop ? 1 : 0)
  }
  
  func setVolume(_ value: Float) {
    alSourcef(source, AL_GAIN, value)
  }
}
