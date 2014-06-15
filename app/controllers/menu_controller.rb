class MenuCell < UITableViewCell

  HEIGHT = 56
  SELECTED_BACKGROUND_COLOR = '#ff9900'.uicolor;
  ICON_FONT = FontAwesome.fontWithSize(17)
  SEPARATOR_COLOR = '#fff'.uicolor(0.3)

  attr_accessor :iconLabel, :textLabel, :emailLabel, :image

  def initWithStyle(style, reuseIdentifier: identifier)
    super
    createLabels
    self
  end

  def createLabels
    clearColor = UIColor.clearColor

    @iconLabel = UILabel.alloc.initWithFrame([[20, 10], [36, 36]])
    @iconLabel.textColor = '#fff'.uicolor
    @iconLabel.backgroundColor = clearColor
    @iconLabel.font = ICON_FONT

    @textLabel = UILabel.alloc.initWithFrame([[56, 15], [243, 21]])
    @textLabel.textColor = '#fff'.uicolor
    @textLabel.backgroundColor = clearColor
    @textLabel.font = 'HelveticaNeue-Light'.uifont(18)

    contentView.addSubview(@iconLabel)
    contentView.addSubview(@textLabel)

    selectedBackgroundView = UIView.alloc.initWithFrame(self.frame)
    selectedBackgroundView.backgroundColor = SELECTED_BACKGROUND_COLOR
    self.selectedBackgroundView = selectedBackgroundView
    self.selectionStyle = UITableViewCellSelectionStyleNone
  end

  def renderForRowAtIndexPath(indexPath)
    self.backgroundColor = UIColor.clearColor
    case indexPath.row
    when 0
      if CurrentUserManager.shared_instance
        @image = UIImageView.alloc.initWithFrame([[10, 5], [36, 36]])

        @emailLabel = UILabel.alloc.initWithFrame([[56, 24], [243, 18]])
        @emailLabel.textColor = '#ccc'.uicolor
        @emailLabel.backgroundColor = UIColor.clearColor
        @emailLabel.font = 'HelveticaNeue-Thin'.uifont(14)

        contentView.addSubview(@image)
        contentView.addSubview(@emailLabel)

        currentUser = CurrentUserManager.shared_instance

        # TODO: figure out how to get user Google+ profile picture to display here
        userImageData = NSData.dataWithContentsOfURL(currentUser.profile_picture.nsurl)
        @image.image = UIImage.imageWithData(userImageData)

        @textLabel.text = currentUser.display_name
        @textLabel.frame = CGRectMake(56, 1, 243, 21)
        @emailLabel.text = currentUser.email
      else
        @textLabel.text = 'Login'
        @iconLabel.text = NSString.fontAwesomeIconStringForIconIdentifier('icon-lock')
      end
    when 1
      @textLabel.text = 'Sign out'
      @iconLabel.text = NSString.fontAwesomeIconStringForIconIdentifier('icon-off')
    end

    if indexPath.row < 4
      bottomBorder = UIView.alloc.initWithFrame([[0, 55], [200, 0.8]])
      bottomBorder.backgroundColor = SEPARATOR_COLOR
      contentView.addSubview(bottomBorder)
    end
  end

end

class MenuController < UIViewController

  include UIViewControllerExtension

  private

  def viewDidLoad
    performHousekeepingTasks
  end

  def performHousekeepingTasks
    frame = self.view.frame
    clearColor = UIColor.clearColor
    @table = createTable(cell: MenuCell, frame: CGRectMake(0, 80, frame.size.width, frame.size.height), background_color: clearColor, separator_color: clearColor)
    view.addSubview(@table)
    view.backgroundColor = MENU_BACKGROUND_COLOR
  end

  def drawGradientBackground
    gradient = CAGradientLayer.layer
    gradient.frame = view.bounds
    gradient.colors = BACKGROUND_GRADIENT
    view.layer.addSublayer(gradient)
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    2
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    MenuCell::HEIGHT
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier(MenuCell.reuseIdentifier) || begin
      MenuCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: MenuCell.reuseIdentifier)
    end

    cell.renderForRowAtIndexPath(indexPath)
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    if indexPath.row == 1
      # Signout
      GPPSignIn.sharedInstance.signOut
      view.window.rootViewController = UINavigationController.alloc.initWithRootViewController(LoginController.new)
    end
  end

  def navigateToSelectedController(controller)
    sideMenuViewController.setContentViewController(controller)
    sideMenuViewController.hideMenuViewController
  end

  def reloadAfterLogin
    @table.reloadData
  end

end