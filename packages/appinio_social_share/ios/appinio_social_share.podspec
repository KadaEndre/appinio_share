#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint appinio_social_share.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'appinio_social_share'
  s.version          = '0.3.2'
  s.summary          = 'Share text, images, files and text-with-image to social media (Facebook, Instagram, Messenger, WhatsApp, Twitter, Telegram, TikTok, SMS, System share, etc.).'
  s.description      = <<-DESC
Flutter plugin for sharing content to social media platforms on iOS.
                       DESC
  s.homepage         = 'https://github.com/appinioGmbH/flutter_packages'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Appinio GmbH' => 'developers@appinio.com' }
  s.source           = { :path => '.' }
  # Sources live under the Swift Package layout so the same files back both
  # CocoaPods and Swift Package Manager. See appinio_social_share/Package.swift.
  s.source_files = 'appinio_social_share/Sources/appinio_social_share/**/*.swift'
  s.dependency 'Flutter'
  s.dependency 'FBSDKCoreKit', '18.0'
  s.dependency 'FBSDKShareKit', '18.0'
  s.static_framework = true

  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
