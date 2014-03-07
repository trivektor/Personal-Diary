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
    UINavigationBar.appearance.setBarTintColor(NAVBAR_TINT_COLOR)
    UIBarButtonItem.appearance.setTintColor(NAVBAR_FONT_COLOR)
    UINavigationBar.appearance.setTitleTextAttributes(
      UITextAttributeFont => NAVBAR_FONT,
      NSForegroundColorAttributeName => NAVBAR_FONT_COLOR
    )

    # CRToastManager
    CRToastManager.setDefaultOptions(
      'kCRToastNotificationTypeKey' => CRToastTypeNavigationBar,
      'kCRToastFontKey' => 'HelveticaNeue-Light'.uifont(16),
      'kCRToastTextColorKey' => '#fff'.uicolor,
      'kCRToastBackgroundColorKey' => '#2ecc71'.uicolor
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
    @facebook.requestWithGraphPath('/me', andDelegate: self)
  end

  def request(request, didLoad: result)
    CurrentUserManager.initWithUser(FacebookUser.new(result))
    FirebaseManager.initWithUser(CurrentUserManager.sharedInstance)

    navController = UINavigationController.alloc.initWithRootViewController(StoriesController.new)
    menuController = MenuController.alloc.init
    sideMenuController = RESideMenu.alloc.initWithContentViewController(navController, menuViewController: menuController)
    sideMenuController.parallaxEnabled = false
    sideMenuController.panGestureEnabled = false
    sideMenuController.contentViewScaleValue = 0.8
    sideMenuController.delegate = UIApplication.sharedApplication.delegate
    @window.rootViewController = sideMenuController
  end

end
