class LoginController < UIViewController

  def viewDidLoad
    super
    navigationItem.title = 'Login'

    init_gpp_signin
    create_login_button
    GPPSignIn.sharedInstance.trySilentAuthentication
  end
  
  def init_gpp_signin
    shared_instance = GPPSignIn.sharedInstance
    shared_instance.shouldFetchGoogleUserID = true
    shared_instance.shouldFetchGoogleUserEmail = true
    shared_instance.shouldFetchGooglePlusUser = true
    shared_instance.scopes = [GPP_AUTH_SCOPE_LOGIN, GPP_AUTH_SCOPE_PROFILE_EMAIL_READ]
    shared_instance.delegate = self
  end

  def create_login_button
    @loginBtn = UIButton.buttonWithType(UIButtonTypeCustom)
    @loginBtn.frame = CGRectMake(20, 200, 280, 62)
    @loginBtn.setBackgroundImage('signin-with-gplus.png'.uiimage, forState: UIControlStateNormal)
    @loginBtn.addTarget(self, action: 'login', forControlEvents: UIControlEventTouchUpInside)
    view.addSubview(@loginBtn)
  end

  def login
    GPPSignIn.sharedInstance.authenticate
  end

  def finishedWithAuth(auth, error: error)
    if error
      NSLog "auth error"
      NSLog error.inspect
    else
      CurrentUserManager.init_with_user(GPlusUser.new(GPPSignIn.sharedInstance))
      FirebaseManager.init_with_user(CurrentUserManager.shared_instance)

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

end