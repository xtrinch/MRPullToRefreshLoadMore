#
# Be sure to run `pod lib lint MRPullToRefreshLoadMore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MRPullToRefreshLoadMore'
  s.version          = '0.0.1'
  s.summary          = 'Easy and simple way to add pull to refresh and load more for table views, collection views and even scrollviews'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Pull to refresh and load more loader with delegate methods for tableviews, collectionviews and scrollviews. Its usage is extremely simple as it onnly requires setting a class on your uiview. Example project contains tableview and horizontally scrolling collectionview. 
                       DESC

  s.homepage         = 'https://github.com/xtrinch/MRPullToRefreshLoadMore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mojca Rojko' => 'mojca.rojko@gmail.com' }
  s.source           = { :git => 'https://github.com/xtrinch/MRPullToRefreshLoadMore.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MRPullToRefreshLoadMore/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MRPullToRefreshLoadMore' => ['MRPullToRefreshLoadMore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
