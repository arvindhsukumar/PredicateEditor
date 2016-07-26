#
# Be sure to run `pod lib lint PredicateEditor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PredicateEditor'
  s.version          = '0.9.1'
  s.summary          = 'A visual editor for dynamically creating NSPredicates to query data in your app.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "PredicateEditor allows users of your apps to dynamically create filters (in the form of NSPredicates) using an easy-to-use GUI, that can then be used to filter data."

  s.homepage         = 'https://github.com/arvindhsukumar/PredicateEditor'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Arvindh Sukumar'
  s.source           = { :git => 'https://github.com/arvindhsukumar/PredicateEditor.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'PredicateEditor/Classes/**/*'
  
  s.resource_bundles = {
     'PredicateEditor' => ['PredicateEditor/Assets/*.png','PredicateEditor/Assets/*.xcassets']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SnapKit', '~> 0.21'
  s.dependency 'SeedStackViewController', '~> 0.2'
  s.dependency 'Timepiece', '~> 0.4'
end
