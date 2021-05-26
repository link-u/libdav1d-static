#
# Be sure to run `pod lib lint TestLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'libdav1d'
  s.version          = '0.0.6'
  s.summary          = 'dav1d is an AV1 decoder :)'
  s.description      = <<-DESC
dav1d is a new AV1 cross-platform decoder, open-source, and focused on speed and correctness.
                       DESC

  s.homepage         = 'https://github.com/videolan/dav1d'
  s.license          = { :type => 'BSD 2-clause' }
  s.author           = { 'Alliance for Open Media' => 'https://aomedia.org' }
  s.platform	    = :ios
  s.source           = { :git => 'git@github.com:link-u/libdav1d-static.git' }
  s.ios.deployment_target = '10.0'
  s.xcconfig = {
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES'
  }
  s.requires_arc = true
  
  s.subspec 'both' do |ss|
    ss.ios.vendored_frameworks = 'libdav1d.xcframework'
  end
  
  s.subspec '8bit' do |ss|
    ss.ios.vendored_frameworks = 'libdav1d-8bit.xcframework'
  end
  
  s.subspec '16bit' do |ss|
    ss.ios.vendored_frameworks = 'libdav1d-16bit.xcframework'
  end
  
  s.default_subspecs = 'both'
  s.prepare_command = <<-CMD
                      mv libdav1d-8bit.xcframework libdav1d.xcframework
                      mv libdav1d-16bit.xcframework libdav1d.xcframework
                      CMD
end
