class AppDelegate

  include CDQ

  attr_accessor :window, :facebook

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.backgroundColor = UIColor.whiteColor
    @window.makeKeyAndVisible

    cdq.setup
    customizeAppearances

    @facebook = Facebook.alloc.initWithAppId(FACEBOOK_KEY, andDelegate:self)

    defaults = NSUserDefaults.standardUserDefaults
    puts defaults.objectForKey("FBAccessToken")
    puts defaults.objectForKey("FBExpirationDate")

    if defaults.objectForKey("FBAccessToken") && defaults.objectForKey("FBExpirationDate")
      @facebook.accessToken = defaults.objectForKey("FBAccessToken")
      @facebook.expirationDate = defaults.objectForKey("FBExpirationDate")
    end

    if @facebook.isSessionValid
      redirectAfterLogin
    else
      @facebook.authorize(FACEBOOK_PERMISSIONS)
    end

    true
  end

  def customizeAppearances
    # UINavigationBar appearance
    UINavigationBar.appearance.setBarTintColor(EMERALD_COLOR)
    UIBarButtonItem.appearance.setTintColor(NAVBAR_FONT_COLOR)
    UINavigationBar.appearance.setTitleTextAttributes(
      UITextAttributeFont => NAVBAR_FONT,
      NSForegroundColorAttributeName => NAVBAR_FONT_COLOR
    )

    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent
    window.tintColor = '#fff'.uicolor

    # CRToastManager
    CRToastManager.setDefaultOptions(
      'kCRToastNotificationTypeKey' => CRToastTypeNavigationBar,
      'kCRToastFontKey' => TOAST_FONT,
      'kCRToastTextColorKey' => TOAST_TEXT_COLOR,
      'kCRToastBackgroundColorKey' => EMERALD_COLOR
    )
  end

  def fbDidLogin
    defaults = NSUserDefaults.standardUserDefaults

    defaults.setObject(@facebook.accessToken, forKey:'FBAccessToken')
    defaults.setObject(@facebook.expirationDate, forKey:'FBExpirationDate')
    NSUserDefaults.standardUserDefaults.synchronize

    redirectAfterLogin
  end

  def fbDidNotLogin
    puts "Login failed!"
  end

  def redirectAfterLogin
    puts "Facebook token is #{@facebook.accessToken}"
    @window.rootViewController = LoadingController.new
  end

end
