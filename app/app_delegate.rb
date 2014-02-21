class AppDelegate

  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.backgroundColor = UIColor.whiteColor
    @window.makeKeyAndVisible

    controller = HomeController.new
    navigationController = UINavigationController.alloc.initWithRootViewController(controller)
    @window.rootViewController = navigationController
    true
  end
end
