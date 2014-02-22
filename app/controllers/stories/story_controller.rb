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
              title: 'Title',
              key: 'title',
              type: 'string',
              placeholder: 'Enter a title here...',
            ),
            mergeRowOptions(
              title: 'Content',
              key: 'content',
              type: 'text',
              row_height: 300,
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
    navigationItem.leftBarButtonItem = createFontAwesomeButton(icon: 'remove', touchHandler: 'cancelStory')
    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'trash', touchHandler: 'reset')
  end

  def performHousekeepingTasks
    navigationItem.title = 'New Story'
  end

  def cancelStory
    dismissViewControllerAnimated(true, completion: nil)
  end

  def createStory
  end

  def reset
    @textView.text = ''
  end

end