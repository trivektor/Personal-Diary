class StoriesController < BaseController

  def viewDidLoad
    performHousekeepingTasks
    registerEvents
    @stories = Story.all
  end

  def performHousekeepingTasks
    super
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

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier('Cell') || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: 'Cell')
    end
    story = tableView(tableView, storyForRowAtIndexPath: indexPath)
    cell.textLabel.text = story.title
    cell.detailTextLabel.text = story.content
    cell
  end

  def tableView(tableView, storyForRowAtIndexPath: indexPath)
    @stories[indexPath.row]
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