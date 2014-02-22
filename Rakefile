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
  app.identifier = 'com.personaldiary'
  
  app.device_family = [:iphone]
  app.sdk_version = '7.0'
  app.provisioning_profile = ENV['MOTION_PROVISIONING_PROFILE']
  app.codesign_certificate = ENV['MOTION_CODESIGN_CERTIFICATE']
  app.detect_dependencies = false
  app.prerendered_icon = true
  app.interface_orientations = [:portrait]

  # Frameworks
  %w(
    QuartzCore
    Security
    CoreAnimation
    Social
    AdSupport
    Accounts
  ).each { |framework| app.frameworks << framework }
  
  app.info_plist['UIViewControllerBasedStatusBarAppearance'] = false

  app.pods do
    pod 'Facebook-iOS-SDK'
    pod 'RESideMenu'
    pod 'FontAwesomeIconFactory'
    pod 'FontAwesome+iOS'
    pod 'AMScrollingNavbar'
    pod 'PSPDFTextView', :git => 'https://github.com/steipete/PSPDFTextView'
  end

end
