#
# Be sure to run `pod lib lint RxExtensions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxExtensions'
  s.version          = '0.0.1'
  s.summary          = 'A short description of RxExtensions.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = `Rx常用的一些扩展`

  s.homepage         = 'https://github.com/anddygon/RxExtensions'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'anddygon' => 'anddygong@gmail.com' }
  s.source           = { :git => 'https://github.com/anddygon/RxExtensions.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform = :ios, "9.0"


  s.source_files = 'RxExtensions/Source/**/*'
  
  # s.resource_bundles = {
  #   'RxExtensions' => ['RxExtensions/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'RxSwift', '~> 4.0.0'
  s.dependency 'RxCocoa', '~> 4.0.0'
  s.dependency 'Moya', '~> 10.0.0'
  s.dependency 'ObjectMapper', '~> 3.0.0'
  s.dependency 'RxOptional', '~> 3.3.0'

end
