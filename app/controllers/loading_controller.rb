class LoadingController < BaseController

  def viewDidLoad
    super
    showProgress
    defaults = NSUserDefaults.standardUserDefaults
    @facebook = Facebook.alloc.initWithAppId(FACEBOOK_KEY, andDelegate: self)
    @facebook.accessToken = defaults.objectForKey("FBAccessToken")
    @facebook.expirationDate = defaults.objectForKey("FBExpirationDate")
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
    view.window.rootViewController = sideMenuController
  end

end