class AppDelegate

  include CDQ

  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.backgroundColor = UIColor.whiteColor

    GPPSignIn.sharedInstance.setClientID(GPP_CLIENT_ID)
    GPPSignIn.sharedInstance.delegate = self
    cdq.setup
    customizeAppearances

    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(LoginController.new)
    @window.makeKeyAndVisible

    true
  end

  def application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    GPPURLHandler.handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
  end

  def customizeAppearances
    # UINavigationBar appearance
    UINavigationBar.appearance.setBarTintColor(EMERALD_COLOR)
    UIBarButtonItem.appearance.setTintColor(NAVBAR_FONT_COLOR)
    UIBarButtonItem.appearance.setTitleTextAttributes({
      UITextAttributeFont => UIFont.fontWithName(APP_FONT_REGULAR, size: 19)
    }, forState: UIControlStateNormal)
    UINavigationBar.appearance.setTitleTextAttributes(
      UITextAttributeFont => UIFont.fontWithName(APP_FONT_REGULAR, size: 25),
      NSForegroundColorAttributeName => NAVBAR_FONT_COLOR
    )

    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent
    window.tintColor = '#fff'.uicolor

    # CRToastManager
    CRToastManager.setDefaultOptions(
      'kCRToastNotificationTypeKey' => CRToastTypeNavigationBar,
      'kCRToastFontKey' => UIFont.fontWithName(APP_FONT_SEMI_BOLD, size: 25),
      'kCRToastTextColorKey' => EMERALD_COLOR,
      'kCRToastBackgroundColorKey' => '#fff'.uicolor
    )
  end

end
