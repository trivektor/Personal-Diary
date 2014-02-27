class MenuCell < UITableViewCell

  HEIGHT = 54
  SELECTED_BACKGROUND_COLOR = '#ff9900'.uicolor;
  TEXT_COLOR = '#fff'.uicolor
  TEXT_FONT = 'HelveticaNeue-Light'.uifont(18)
  ICON_FONT = FontAwesome.fontWithSize(17)
  SEPARATOR_COLOR = '#fff'.uicolor(0.2)

  attr_accessor :iconLabel, :textLabel, :image

  def initWithStyle(style, reuseIdentifier: identifier)
    super
    createLabels
    self
  end

  def createLabels
    clearColor = UIColor.clearColor

    @iconLabel = UILabel.alloc.initWithFrame([[15, 14], [25, 25]])
    @iconLabel.textColor = TEXT_COLOR
    @iconLabel.backgroundColor = clearColor
    @iconLabel.font = ICON_FONT

    @textLabel = UILabel.alloc.initWithFrame([[53, 12], [243, 21]])
    @textLabel.textColor = TEXT_COLOR
    @textLabel.backgroundColor = clearColor
    @textLabel.font = TEXT_FONT

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
      if CurrentUserManager.sharedInstance
        @image = UIImageView.alloc.initWithFrame([[15, 9], [25, 25]])

        contentView.addSubview(@image)

        currentUser = CurrentUserManager.sharedInstance
        userImageData = NSData.dataWithContentsOfURL(currentUser.profile_picture.nsurl)
        @image.image = UIImage.imageWithData(userImageData)
        @image.layer.masksToBounds = true
        @image.layer.cornerRadius = 3
        @textLabel.text = currentUser.full_name
      else
        @textLabel.text = 'Login'
        @iconLabel.text = NSString.fontAwesomeIconStringForIconIdentifier('icon-lock')
      end
    end

    if indexPath.row < 4
      bottomBorder = UIView.alloc.initWithFrame([[0, 53], [180, 0.5]])
      bottomBorder.backgroundColor = SEPARATOR_COLOR
      contentView.addSubview(bottomBorder)
    end
  end

end

class MenuController < UIViewController

  include UIViewControllerExtension

  BACKGROUND_COLOR = '#222'.uicolor

  private

  def viewDidLoad
    performHousekeepingTasks
    registerEvents
  end

  def performHousekeepingTasks
    frame = self.view.frame
    clearColor = UIColor.clearColor
    @table = createTable(cell: MenuCell, frame: CGRectMake(0, 80, frame.size.width, frame.size.height), background_color: clearColor, separator_color: clearColor)
    view.backgroundColor = BACKGROUND_COLOR
    view.addSubview(@table)
  end

  def registerEvents
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    1
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
  end

  def navigateToSelectedController(controller)
    sideMenuViewController.setContentViewController(controller)
    sideMenuViewController.hideMenuViewController
  end

  def reloadAfterLogin
    @table.reloadData
  end

end