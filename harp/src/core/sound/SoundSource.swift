import Foundation

// Force to instatinate from factory.
// Concrete implementation is inner SoundPlayerFactory

protocol SoundSource {
  func play()
  func stop()
  func pause()
  func setOffset(second: Float)
  func setShouldLooping(_ shouldLoop: Bool)
  func setVolume(_ value: Float)
}
