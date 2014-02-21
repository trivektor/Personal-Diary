class AppDelegate

  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.backgroundColor = UIColor.whiteColor
    @window.makeKeyAndVisible

    blackColor = '#111'.uicolor
    UINavigationBar.appearance.setTintColor(blackColor)
    UIBarButtonItem.appearance.setTintColor(blackColor)

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
