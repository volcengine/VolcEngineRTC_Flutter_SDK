#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint volc_engine_rtc.podspec` to validate before publishing.
#
require "yaml"
require "ostruct"
project = OpenStruct.new YAML.load_file("../pubspec.yaml")

Pod::Spec.new do |s|
  s.name             = project.name
  s.version          = project.version
  s.summary          = 'A new flutter plugin project.'
  s.description      = project.description
  s.homepage         = project.homepage
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'bytertc' => 'bytertc@bytedance.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/*.h'
  s.dependency 'Flutter'
  s.dependency 'VolcEngineRTC/Core', '3.58.1.19400'
  s.dependency 'VolcEngineRTC/RealXBase', '3.58.1.19400'
  s.ios.deployment_target = '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'EXCLUDED_ARCHS[sdk=iphoneos*]' => 'x86_64', 'ENABLE_BITCODE' => 'NO'}
end
