Pod::Spec.new do |s|
  s.name     = 'UuusKit'
  s.version  = '4.0.1.1'
  s.license  = 'MIT'
  s.summary  = 'UuusKit is a Swift extension, requires Swift 4.0 or higher.'
  s.homepage = 'https://github.com/wadevanne/UuusKit'
  s.author   = { 'wadevanne' => 'wadevanne@icloud.com' }
  s.platform = :ios, '9.0'
  s.source   = { :git => 'https://github.com/wadevanne/UuusKit.git', :tag => s.version }
  s.source_files = 'UuusKit/**/*.{swift}'
  s.resources = 'UuusKit/**/*.{xib,xcassets,imageset,plist,json,png,storyboard}'
  s.requires_arc = true
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
  s.dependency 'AlamofireImage'
  s.dependency 'KeychainAccess'
  s.dependency 'ObjectMapper'
  s.dependency 'PKHUD'
  s.dependency 'PullToRefresher'
  s.dependency 'RMUniversalAlert'
  s.dependency 'RxCocoa'
  s.dependency 'RxSwift'
  s.dependency 'SnapKit'
  s.dependency 'SwiftFormat/CLI'
end
