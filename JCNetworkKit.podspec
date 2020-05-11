#
# Be sure to run `pod lib lint JCNetworkKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JCNetworkKit'
  s.version          = '0.1.0'
  s.summary          = 'JCNetworkKit, an easy solution to handle your network.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: 'JCNetworkKit, an easy solution to handle your network. 透過針對AFNetworking進行二次封裝來方便網路連線的工具'
                       DESC

  s.homepage         = 'https://github.com/iverson1234tw/JCNetworkKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Chen-Hung-Wei' => 'reno65072013@gmail.com' }
  s.source           = { :git => 'https://github.com/iverson1234tw/JCNetworkKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'JCNetworkKit/Classes/'
  
  # s.resource_bundles = {
  #   'JCNetworkKit' => ['JCNetworkKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'AFNetworking', '~> 3.0'
  s.dependency 'MBProgressHUD', '~> 1.1.0'
end
