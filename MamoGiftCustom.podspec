#
# Be sure to run `pod lib lint MamoGiftCustom.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MamoGiftCustom'
  s.version          = '1.0.1'
  s.summary          = 'A short description of MamoGiftCustom.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/fangdada1/MamoGiftCustom'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fangdada1' => '120435977+fangdada1@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/fangdada1/MamoGiftCustom.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'MamoGiftCustom/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MamoGiftCustom' => ['MamoGiftCustom/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SDWebImage', '~> 5.18.7'
end
