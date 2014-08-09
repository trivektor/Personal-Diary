class StoriesController < BaseController

  attr_accessor :table, :stories, :animator

  ROW_HEIGHT = 70
  VIEW_BUTTON_TITLE = 'view'
  DELETE_BUTTON_TITLE = 'delete'

  def viewDidLoad
    @stories = []
    performHousekeepingTasks
    showProgress
  end

  def performHousekeepingTasks
    super
    setupFirebase
    updateTitle
    @table = createTable
    view.addSubview(@table)
    initAMScrollingNavbar(@table)
    createBarButtonItems
  end

  def setupFirebase
    FirebaseManager.shared_instance.observeEventType(FEventTypeValue, withBlock: lambda do |snapshot|
      @stories = []

      if snapshot.value.is_a? Hash
        @stories += snapshot.value.map do |key, story_attrs|
          Story.new(key, story_attrs)
        end.sort_by(&:timestamp).reverse
      end

      updateTitle
      @table.reloadData
      hideProgress
    end)
  end

  def createBarButtonItems
    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'pencil', touchHandler: 'createStory')
  end

  def updateTitle
    navigationItem.title = "Stories (#{@stories.count})"
  end

  def numberOfSectionInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @stories.count
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    ROW_HEIGHT
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier('MSCMoreOptionTableViewCell') || begin
      MSCMoreOptionTableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: 'MSCMoreOptionTableViewCell')
    end
    story = tableView(tableView, storyForRowAtIndexPath: indexPath)
    cell.textLabel.text = story.title
    cell.textLabel.textColor = NEPHRITIS_COLOR
    cell.textLabel.font = UIFont.fontWithName(APP_FONT_REGULAR, size: 19)
    cell.detailTextLabel.text = story.time_and_location
    cell.detailTextLabel.font = UIFont.fontWithName(APP_FONT_REGULAR, size: 14)
    cell.selectionStyle = UITableViewCellSelectionStyleNone
    cell.delegate = self
    cell
  end

  def tableView(tableView, storyForRowAtIndexPath: indexPath)
    @stories[indexPath.row]
  end

  def tableView(tableView, canEditRowAtIndexPath: indexPath)
    true
  end

  def tableView(tableView, commitEditingStyle: editingStyle, forRowAtIndexPath: indexPath)
    @deleteConfirmDialog = CXAlertView.alloc.initWithTitle(
      'Wait!',
      message: 'Are you sure you want to delete this story?',
      cancelButtonTitle: 'Cancel'
    )

    @deleteConfirmDialog.addButtonWithTitle(
      'OK',
      type: CXAlertViewButtonTypeDefault,
      handler: lambda do |alertView, button|
        tableView(tableView, deleteStoryAtIndexPath: indexPath)
        @deleteConfirmDialog.dismiss
      end
    )
    @deleteConfirmDialog.show
  end

  def tableView(tableView, editingStyleForRowAtIndexPath: indexPath)
    UITableViewCellEditingStyleDelete
  end

  def tableView(tableView, titleForMoreOptionButtonForRowAtIndexPath: indexPath)
    VIEW_BUTTON_TITLE
  end

  def tableView(tableView, titleColorForMoreOptionButtonForRowAtIndexPath: indexPath)
    '#fff'.uicolor
  end

  def tableView(tableView, backgroundColorForMoreOptionButtonForRowAtIndexPath: indexPath)
    PETER_RIVER_COLOR
  end

  def tableView(tableView, titleForDeleteConfirmationButtonForRowAtIndexPath: indexPath)
    DELETE_BUTTON_TITLE
  end

  def tableView(tableView, titleColorForDeleteConfirmationButtonForRowAtIndexPath: indexPath)
    '#fff'.uicolor
  end

  def tableView(tableView, backgroundColorForDeleteConfirmationButtonForRowAtIndexPath: indexPath)
    ALIZARIN_COLOR
  end

  def tableView(tableView, moreOptionButtonPressedInRowAtIndexPath: indexPath)
    story = tableView(tableView, storyForRowAtIndexPath: indexPath)
    controller = StoryController.alloc.initWithStory(story)
    navigationController.pushViewController(controller, animated: true)
  end

  def tableView(tableView, deleteStoryAtIndexPath: indexPath)
    story = tableView(tableView, storyForRowAtIndexPath: indexPath)
    story.destroy
  end

  def createStory
    navigationController.pushViewController(StoryComposeController.new, animated: true)
  end

end