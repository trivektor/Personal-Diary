class StoriesController < BaseController

  ROW_HEIGHT = 64
  VIEW_BUTTON_TITLE_COLOR = '#fff'.uicolor
  VIEW_BUTTON_BACKGROUND_COLOR = '#3498db'.uicolor
  VIEW_BUTTON_TITLE = 'view'
  DELETE_BUTTON_TITLE_COLOR = '#fff'.uicolor
  DELETE_BUTTON_BACKGROUND_COLOR = '#e74c3c'.uicolor
  DELETE_BUTTON_TITLE = 'delete'

  def viewDidLoad
    @stories = Story.all
    performHousekeepingTasks
    registerEvents
  end

  def performHousekeepingTasks
    navigationItem.title = 'Stories'
    @table = createTable
    view.addSubview(@table)

    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'pencil', touchHandler: 'createStory')
  end

  def registerEvents
    'StoryCreated'.add_observer(self, 'reload')
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
    cell.detailTextLabel.text = story.content
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
    # TO BE IMPLEMENTED
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

  def createStory
    controller = UINavigationController.alloc.initWithRootViewController(NewStoryController.new)
    controller.modalPresentationStyle = UIModalPresentationFormSheet
    presentViewController(controller, animated: true, completion: nil)
  end

  def reload
    @table.reloadData
  end

end