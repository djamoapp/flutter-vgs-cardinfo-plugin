#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint vgscardinfo.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'vgscardinfo'
  s.version          = '0.0.1'
  s.summary          = 'Plugin to display VGS Card infos.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://djamo.ci'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Djamo' => 'info@djamo.ci' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'VGSShowSDK'
  s.platform = :ios, '10.0'
  s.resources = 'Assets/*'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
