#
# Be sure to run `pod lib lint BoundarySlider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BoundarySlider'
  s.version          = '0.1.0'
  s.summary          = 'A short description of BoundarySlider.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/AnbalaganD/BoundarySlider'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anbalagan D' => 'anbu94p@gmail.com' }
  s.source           = { :git => 'https://github.com/AnbalaganD/BoundarySlider.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '15.0'

  s.source_files = 'BoundarySlider/Classes/**/*'
end
