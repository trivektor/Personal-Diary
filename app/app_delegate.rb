class AppDelegate

  include CDQ

  attr_accessor :window

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
      @facebook.authorize nil
    end

    true
  end

  def customizeAppearances
    # UINavigationBar appearance
    blackColor = '#111'.uicolor
    UINavigationBar.appearance.setTintColor(blackColor)
    UIBarButtonItem.appearance.setTintColor(blackColor)
    UINavigationBar.appearance.setTitleTextAttributes(
      UITextAttributeFont => 'HelveticaNeue-Light'.uifont(22)
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
    puts 'Facebook did login'
    defaults = NSUserDefaults.standardUserDefaults
    puts @facebook.accessToken
    #puts @facebook.expirationDate

    defaults.setObject(@facebook.accessToken, forKey:'FBAccessToken')
    defaults.setObject(@facebook.expirationDate, forKey:'FBExpirationDate')
    NSUserDefaults.standardUserDefaults.synchronize

    puts "Login succeeded!"
    redirectAfterLogin
  end

  def fbDidNotLogin
    puts "Login failed!"
  end

  def redirectAfterLogin
    navController = UINavigationController.alloc.initWithRootViewController(StoriesController.new)
    # menuController = MenuController.alloc.init
    # sideMenuController = RESideMenu.alloc.initWithContentViewController(navController, menuViewController: menuController)
    @window.rootViewController = navController
  end

end
