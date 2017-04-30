platform :osx, '10.10'

target 'harp' do
  use_frameworks!

  # Pods for harp
  pod 'RxSwift', '~> 3.0'
  pod 'RxCocoa', '~> 3.0'
  pod 'SwiftGen', '~> 4.0'
  pod 'XCGLogger', '~> 4.0'
  pod 'Swinject', '2.0.0'

  target 'harpTests' do
    inherit! :search_paths

    # Pods for testing
    pod 'Quick', '~> 1.0'
    pod 'Nimble', '~> 5.0'
    pod 'RxBlocking', '~> 3.0'
    pod 'RxTest', '~> 3.0'
  end

end
