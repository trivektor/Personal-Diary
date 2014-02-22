class StoryController < BaseController
end

class NewStoryController < Formotion::FormController

  include UIViewControllerExtension

  def init
    form = Formotion::Form.new(
      sections: [
        {
          rows: [
            mergeRowOptions(
              title: nil,
              key: 'title',
              type: 'string',
              placeholder: 'Title...',
            ),
            mergeRowOptions(
              title: nil,
              key: 'content',
              type: 'text',
              row_height: 300,
              placeholder: 'Content...'
            ),
            mergeRowOptions(
              title: 'Tags',
              type: 'tags'
            ),
            mergeRowOptions(
              title: 'Reset',
              type: 'button'
            )
          ]
        }
      ]
    )

    form.on_submit { createStory }
    super.initWithForm(form)
  end

  def viewDidLoad
    super
    performHousekeepingTasks
  end

  def performHousekeepingTasks
    navigationItem.title = 'New Story'
    view.backgroundColor = '#fff'.uicolor

    @gestureRecognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action: 'hideKeyboard')
    self.tableView.addGestureRecognizer(@gestureRecognizer)

    navigationItem.leftBarButtonItem = createFontAwesomeButton(icon: 'remove', touchHandler: 'cancelStory')
    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'ok-sign', touchHandler: 'createStory')
  end

  def cancelStory
    dismissViewControllerAnimated(true, completion: nil)
  end

  def createStory

  end

  def reset
    @textView.text = ''
  end

  def hideKeyboard
    view.endEditing(true)
  end

end