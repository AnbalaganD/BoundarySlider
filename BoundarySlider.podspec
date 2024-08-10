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
  s.summary          = 'We can add boundary indicators to this slider, like ads, similar to those found in video sliders on many OTT platforms.'
  s.description      = <<-DESC
  This slider has a lot of cool features like boundary indicator support, buffer indicator, and much more. This will help you quickly add a more customizable slider view, like those on major OTT platforms, without worrying too much about implementation details and allowing you to focus on business logic.
                       DESC

  s.homepage         = 'https://github.com/AnbalaganD/BoundarySlider'
  s.screenshots     = 'https://github.com/AnbalaganD/BoundarySlider/blob/main/Screenshot/slider.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anbalagan D' => 'anbu94p@gmail.com' }
  s.source           = { :git => 'https://github.com/AnbalaganD/BoundarySlider.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.linkedin.com/in/anbalagan-d-659b08a8/'

  s.ios.deployment_target = '15.0'

  s.source_files = 'BoundarySlider/Classes/**/*'
end
