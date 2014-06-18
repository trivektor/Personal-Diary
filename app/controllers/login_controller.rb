class LoginController < UIViewController

  include UIViewControllerExtension

  def viewDidLoad
    super
    navigationItem.title = 'Login'
    showProgress
    init_gpp_signin

    if GPPSignIn.sharedInstance.hasAuthInKeychain
      start_app
    else
      hideProgress
      create_login_button
    end
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
      hideProgress
      NSLog "auth error"
      NSLog error.inspect
    elsif auth
      start_app
    end
  end

  def start_app
    CurrentUserManager.init_with_user(GPlusUser.new(GPPSignIn.sharedInstance))
    FirebaseManager.init_with_user(CurrentUserManager.shared_instance)

    navController = UINavigationController.alloc.initWithRootViewController(StoriesController.new)
    menuController = MenuController.alloc.init
    sideMenuController = RESideMenu.alloc.initWithContentViewController(navController, menuViewController: menuController)
    sideMenuController.parallaxEnabled = false
    sideMenuController.panGestureEnabled = false
    sideMenuController.contentViewScaleValue = 1
    sideMenuController.contentViewInPortraitOffsetCenterX = 425
    sideMenuController.delegate = UIApplication.sharedApplication.delegate

    view.window.rootViewController = sideMenuController
  end

end