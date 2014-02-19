class AppDelegate

  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.backgroundColor = UIColor.whiteColor
    @window.makeKeyAndVisible

    SimpleAuth.configuration['facebook-web'] = {
      app_id: FACEBOOK_KEY,
      permissions: ['email'],
      consumer_key: FACEBOOK_KEY,
      consumer_secret: FACEBOOK_SECRET
    }

    controller = HomeController.new
    navigationController = UINavigationController.alloc.initWithRootViewController(controller)
    @window.rootViewController = navigationController
    true
  end
end
