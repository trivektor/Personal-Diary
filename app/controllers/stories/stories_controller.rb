class StoriesController < BaseController

  attr_accessor :table, :stories, :animator

  ROW_HEIGHT = 70
  VIEW_BUTTON_TITLE_COLOR = '#fff'.uicolor
  VIEW_BUTTON_BACKGROUND_COLOR = '#1ccaff'.uicolor
  VIEW_BUTTON_TITLE = 'view'
  DELETE_BUTTON_TITLE_COLOR = '#fff'.uicolor
  DELETE_BUTTON_BACKGROUND_COLOR = '#ff312d'.uicolor
  DELETE_BUTTON_TITLE = 'delete'
  TITLE_FONT = 'HelveticaNeue-Light'.uifont(17)
  CREATION_DATE_FONT = 'HelveticaNeue-Thin'.uifont(14)

  def viewDidLoad
    @stories = []
    performHousekeepingTasks
    fetchStoriesFromFirebase
    showProgress
  end

  def performHousekeepingTasks
    super
    updateTitle
    @table = createTable
    view.addSubview(@table)
    initAMScrollingNavbar(@table)
    createBarButtonItems
  end

  def fetchStoriesFromFirebase
    @firebase = FirebaseManager.sharedInstance.observeEventType(FEventTypeValue, withBlock: lambda do |snapshot|
      unless snapshot.value.is_a? Hash
        hideProgress
        break
      end
      @stories = snapshot.value.map do |key, story_attrs|
        Story.new(key, story_attrs)
      end.sort_by(&:timestamp).reverse
      updateTitle
      @table.reloadData
      hideProgress
    end)
  end

  def createBarButtonItems
    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'pencil', touchHandler: 'createStory')
  end

  def registerEvents
    'StoryCreated'.add_observer(self, 'fetchStoriesFromFirebase')
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
    cell.textLabel.font = TITLE_FONT
    cell.detailTextLabel.text = story.timeAndLocation
    cell.detailTextLabel.font = CREATION_DATE_FONT
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
    VIEW_BUTTON_TITLE_COLOR
  end

  def tableView(tableView, backgroundColorForMoreOptionButtonForRowAtIndexPath: indexPath)
    VIEW_BUTTON_BACKGROUND_COLOR
  end

  def tableView(tableView, titleForDeleteConfirmationButtonForRowAtIndexPath: indexPath)
    DELETE_BUTTON_TITLE
  end

  def tableView(tableView, titleColorForDeleteConfirmationButtonForRowAtIndexPath: indexPath)
    DELETE_BUTTON_TITLE_COLOR
  end

  def tableView(tableView, backgroundColorForDeleteConfirmationButtonForRowAtIndexPath: indexPath)
    DELETE_BUTTON_BACKGROUND_COLOR
  end

  def tableView(tableView, moreOptionButtonPressedInRowAtIndexPath: indexPath)
    story = tableView(tableView, storyForRowAtIndexPath: indexPath)
    controller = StoryController.alloc.initWithStory(story)
    navigationController.pushViewController(controller, animated: true)
  end

  def tableView(tableView, deleteStoryAtIndexPath: indexPath)
    story = tableView(tableView, storyForRowAtIndexPath: indexPath)
    story.destroy
    cdq.save
    reload
  end

  def createStory
    controller = UINavigationController.alloc.initWithRootViewController(NewStoryController.new)
    controller.modalPresentationStyle = UIModalPresentationCustom
    self.animator = ZFModalTransitionAnimator.alloc.initWithModalViewController(controller)
    animator.direction = ZFModalTransitonDirectionRight
    controller.transitioningDelegate = animator
    presentViewController(controller, animated: true, completion: nil)
  end

  def reload
    @table.reloadData
    updateTitle
  end

end