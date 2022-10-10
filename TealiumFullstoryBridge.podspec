Pod::Spec.new do |s|

  s.name         = "TealiumFullstoryBridge"
  s.module_name  = "FullstoryBridge"
  s.version      = "1.31.0"
  s.summary      = "Bridge to pull in FullStory framework"
  s.description  = ""

  s.homepage     = "https://github.com/tealium/tealium-ios-fullstory-remote-command" 
  s.platform = :ios, "10.0"
  s.ios.deployment_target = "10.0"
  s.license      = { :type => "MIT", :file => "LICENSE.txt" }
  s.author             = { "Tealium Inc." => "tealium@tealium.com" }

  s.source       = { :http => "https://ios-releases.fullstory.com/fullstory-#{s.version}-xcframework.tar.gz" :flatten  => true }
  s.ios.vendored_frameworks  = "FullStory.framework"
end
