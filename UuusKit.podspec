Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  s.name         = "UuusKit"
  s.version      = "3.9.9.1"
  s.summary      = "UuusKit is a Swift extension, requires Swift 4.0 or higher."
  s.description  = <<-DESC
                    UuusKit is a Swift extension, requires Swift 4.0.0 or higher.
                    It's more convenient to use Swift with some common functions.
                   DESC

  s.homepage     = "https://github.com/wadevanne/UuusKit"
# s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  s.license      = "MIT"
# s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  s.author             = { "wadevanne" => "wadevanne@icloud.com" }
# Or just: s.author    = "wadevanne"
# s.authors            = { "wadevanne" => "wadevanne@icloud.com" }
# s.social_media_url   = "http://twitter.com/wadevanne"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  s.platform     = :ios, "9.0"
# s.ios.deployment_target = "5.0"
# s.osx.deployment_target = "10.7"
# s.watchos.deployment_target = "2.0"
# s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  s.source       = { :git => "https://github.com/wadevanne/UuusKit.git", :tag => s.version }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  s.source_files  = "Classes", "UuusKit/**/*.{swift}"
  s.exclude_files = "Classes/Exclude"
# s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
# s.resource  = "icon.png"
  s.resources = "UuusKit/**/*.{xib,xcassets,imageset,plist,json,png,storyboard}"
# s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  s.requires_arc = true
# s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
  s.dependency "ALCameraViewController"
  s.dependency "AlamofireImage"
  s.dependency "KeychainAccess"
  s.dependency "ObjectMapper"
  s.dependency "PKHUD"
  s.dependency "PullToRefresher"
  s.dependency "RMUniversalAlert"
  s.dependency "RxCocoa"
  s.dependency "RxSwift"
  s.dependency "SnapKit"
  s.dependency "SwiftFormat/CLI"

end
