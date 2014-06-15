class LoginController < UIViewController

  def viewDidLoad
    super
    navigationItem.title = 'Login'

    init_GPP_signin
    @loginBtn = UIButton.alloc.initWithFrame([[40, 200], [240, 100]])
    @loginBtn.backgroundColor = ALIZARIN_COLOR
    @loginBtn.addTarget(self, action: 'login', forControlEvents: UIControlEventTouchUpInside)
    @loginBtn.title = 'Login with Google+'
    @loginBtn.setTitleColor('#fff'.uicolor, forState: UIControlStateNormal)
    view.addSubview(@loginBtn)

    GPPSignIn.sharedInstance.trySilentAuthentication
  end
  
  def init_GPP_signin
    shared_instance = GPPSignIn.sharedInstance
    shared_instance.shouldFetchGoogleUserID = true
    shared_instance.shouldFetchGoogleUserEmail = true
    shared_instance.shouldFetchGooglePlusUser = true
    shared_instance.scopes = [GPP_AUTH_SCOPE_LOGIN, GPP_AUTH_SCOPE_PROFILE_EMAIL_READ]
    shared_instance.delegate = self
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