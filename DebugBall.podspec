#
# Be sure to run `pod lib lint DebugBall.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DebugBall'
  s.version          = '1.1.3'
  s.summary          = '一个轻量级的Debug调试工具'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '一个轻量级的Debug调试工具，一键设置API Host/H5 API Host,以及其它的一些Debug UI调试工具'

  s.homepage         = 'https://github.com/pjocer/DebugBall'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pjocer' => 'pjocer@outlook.com' }
  s.source           = { :git => 'https://github.com/pjocer/DebugBall.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'DebugBall/Classes/**/*'
  
    s.resource_bundles = {
        'DebugBall' => ['DebugBall/Assets/*']
    }

    s.public_header_files = 'DebugBall/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
    s.dependency 'QMUIKit', '2.7.1'
end
