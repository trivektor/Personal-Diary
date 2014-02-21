class BaseController < AMScrollingNavbarViewController

  include UIViewControllerExtension

  def performHousekeepingTasks
    if navigationController.viewControllers.count == 1
      menuButton = UIBarButtonItem.alloc.initWithImage('399-list1.png'.uiimage, landscapeImagePhone: nil, style: UIBarButtonItemStyleBordered, target: self, action: 'showMenu')
      navigationItem.leftBarButtonItem = menuButton
    end
  end

  def initAMScrollingNavbar
    if @table
      navigationController.navigationBar.translucent = false
      followScrollView(@table)
    end
  end

  def showMenu
    sideMenuViewController.presentMenuViewController
  end

  def scrollViewShouldScrollToTop(scrollView)
    showNavbar
    true
  end

end