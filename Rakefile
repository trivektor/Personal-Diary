# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bubble-wrap/all'
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Personal-Diary'
  app.identifier = 'com.myapp.personaldiary'
  
  app.device_family = [:iphone]
  app.sdk_version = '7.1'
  app.provisioning_profile = ENV['MOTION_PROVISIONING_PROFILE']
  app.codesign_certificate = ENV['MOTION_CODESIGN_CERTIFICATE']
  app.detect_dependencies = false
  app.prerendered_icon = true
  app.interface_orientations = [:portrait]

  app.entitlements['keychain-access-groups'] = [
    app.seed_id + '.' + app.identifier
  ]

  app.libs += ['/usr/lib/libicucore.dylib', '/usr/lib/libc++.dylib']

  app.vendor_project('vendor/iSpeechSDK', :static, :products => ["libiSpeechSDK.a"], :headers_dir => "Headers")
  app.vendor_project('vendor/GoogleOpenSource.framework', :static, :products => ['GoogleOpenSource'] , :headers_dir => 'Headers')
  app.vendor_project('vendor/GooglePlus.framework', :static, :products => ['GooglePlus'] , :headers_dir => 'Headers')

  # Fonts
  app.fonts += [
    'Lato-Hai.ttf',
    'Lato-Lig.ttf',
    'Lato-Reg.ttf',
    'Lato-Bol.ttf',
    'JosefinSans-Regular.ttf',
    'JosefinSans-Light.ttf',
    'JosefinSans-LightItalic.ttf',
    'JosefinSans-SemiBold.ttf',
    'JosefinSans-Thin.ttf'
  ]

  # Frameworks
  %w(
    UIKit
    CoreFoundation
    CoreGraphics
    CoreMedia
    CoreMotion
    CoreLocation
    CoreData
    CoreText
    SystemConfiguration
    QuartzCore
    Security
    Social
    AdSupport
    Accounts
    AudioToolbox
    AVFoundation
    CFNetwork
    Security
    AddressBook
    AssetsLibrary
  ).each { |framework| app.frameworks << framework }

  app.info_plist['UIViewControllerBasedStatusBarAppearance'] = false

  # This is how you register a new URL scheme, took me a while to figure out
  app.info_plist['CFBundleURLTypes'] = [{
    'CFBundleURLSchemes' => ['com.myapp.personaldiary'],
    'CFBundleURLName' => 'com.myapp.personaldiary'
  }]

  app.pods do
    pod 'RESideMenu'
    pod 'FontAwesomeIconFactory'
    pod 'FontAwesome+iOS'
    pod 'AMScrollingNavbar'
    pod 'CRToast'
    pod 'MSCMoreOptionTableViewCell'
    pod 'NSDate+TimeAgo'
    pod 'GRMustache'
    pod 'SpinKit'
    pod 'BFNavigationBarDrawer', :git => 'https://github.com/DrummerB/BFNavigationBarDrawer'
    pod 'REMenu'
    pod 'ZFDragableModalTransition'
    pod 'CBZSplashView'
  end

end
