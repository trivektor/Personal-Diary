# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Personal-Diary'
  app.identifier = 'com.personaldiary.'
  
  app.device_family = [:iphone]
  app.sdk_version = '7.0'
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
  app.vendor_project('vendor/Firebase.framework', :static, :products => ['Firebase'] , :headers_dir => 'Headers')

  # Frameworks
  %w(
    UIKit
    CoreFoundation
    CoreGraphics
    CoreMedia
    SystemConfiguration
    QuartzCore
    Security
    Social
    AdSupport
    Accounts
    CoreData
    AudioToolbox
    AVFoundation
    CFNetwork
    Security
  ).each { |framework| app.frameworks << framework }

  app.info_plist['UIViewControllerBasedStatusBarAppearance'] = false

  app.pods do
    pod 'Facebook-iOS-SDK'
    pod 'RESideMenu'
    pod 'FontAwesomeIconFactory'
    pod 'FontAwesome+iOS'
    pod 'AMScrollingNavbar'
    pod 'CRToast'
    pod 'MSCMoreOptionTableViewCell'
    pod 'CXAlertView'
    pod 'NSDate+TimeAgo'
    pod 'WebViewJavascriptBridge'
    pod 'GRMustache'
  end

end
