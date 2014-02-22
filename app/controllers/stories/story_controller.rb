class StoryController < BaseController
end

class NewStoryController < BaseController
  def viewDidLoad
    performHousekeepingTasks
    navigationItem.leftBarButtonItem = createFontAwesomeButton(icon: 'remove', touchHandler: 'cancelStory')
    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'trash', touchHandler: 'reset')
  end

  def performHousekeepingTasks
    navigationItem.title = 'New Story'
    @textView = PSPDFTextView.alloc.initWithFrame(view.bounds)
    @textView.delegate = self
    @textView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth
    @textView.font = 'HelveticaNeue-Light'.uifont(20)
    @textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive
    view.addSubview(@textView)
  end

  def cancelStory
    dismissViewControllerAnimated(true, completion: nil)
  end

  def reset
    @textView.text = ''
  end

end