class StoryComposeController < ZSSRichTextEditor

  include UIViewControllerExtension

  def viewDidLoad
    super
    performHousekeepingTasks
  end

  def performHousekeepingTasks
    self.title = 'New Story'
    self.baseURL = 'http://www.zedsaid.com'.nsurl
    self.setHTML("<!-- This is an HTML comment -->")
  end

end