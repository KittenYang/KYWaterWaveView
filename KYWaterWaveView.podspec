Pod::Spec.new do |s|
  s.name         = "KYWaterWaveView"
  s.version      = "0.1.0"
  s.summary      = "Smooth wave animation view for iOS in Objective-C."
  s.homepage     = "https://github.com/KittenYang/KYWaterWaveView"
  s.license      = 'MIT'
  s.author       = { "0dayZh" => "0day.zh@gmail.com" }
  s.ios.deployment_target = '7.0'
  s.source       = { :git => "https://github.com/KittenYang/KYWaterWaveView.git", :tag => s.version }

  s.public_header_files = 'KYWaterWaveView/*.h'
  s.source_files = 'KYWaterWaveView/*.{h,m}'
  s.requires_arc = true
  s.framework    = 'UIKit'
end
