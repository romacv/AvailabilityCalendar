#
# Be sure to run `pod lib lint AvailabilityCalendar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AvailabilityCalendar'
  s.version          = '1.0.0'
  s.summary          = 'AvailabilityCalendar - wonderful, lightweight and highly customizable calendar solution with the ability to specify availability/unavailability of dates. The component is written in SwiftUI, but you can easily represent it in UIKit as well.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/romacv/AvailabilityCalendar'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'romacv' => 'r@resrom.com' }
  s.source           = { :git => 'https://github.com/romacv/AvailabilityCalendar.git', :tag => s.version.to_s }
  s.social_media_url = 'https://resrom.com'

  s.ios.deployment_target = '13.0'

  s.source_files = 'Sources/AvailabilityCalendar/**/*'
  
  # s.resource_bundles = {
  #   'AvailabilityCalendar' => ['AvailabilityCalendar/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
