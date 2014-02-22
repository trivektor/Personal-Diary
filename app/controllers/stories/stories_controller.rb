class StoriesController < BaseController

  def viewDidLoad
    performHousekeepingTasks
    @stories = []
  end

  def performHousekeepingTasks
    super
    navigationItem.title = 'Stories'
    @table = createTable
    view.addSubview(@table)

    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'pencil', touchHandler: 'createStory')
  end

  def numberOfSectionInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @stories.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    nil
  end

  def createStory
  end

end