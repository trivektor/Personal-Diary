class StoryController < BaseController

  attr_accessor :story

  def initWithStory(story)
    @story = story
    self
  end

  def viewDidLoad
    performHousekeepingTasks
  end

  def performHousekeepingTasks
    navigationItem.title = 'Story'
  end

end

class NewStoryController < Formotion::FormController

  include UIViewControllerExtension

  SPEECH_TIMEOUT = 20

  attr_accessor :story, :form, :speechSDK, :speechRecognition, :titleTextField, :contentTextView

  def init
    setupSpeechRecognition
    @form ||= Formotion::Form.new(
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


    @form.on_submit { createStory }
    super.initWithForm(@form)
  end

  def setupSpeechRecognition
    @speechSDK = NSClassFromString('iSpeechSDK').sharedSDK
    @speechSDK.APIKey = ISPEECH_API_KEY
    @speechRecognition = ISSpeechRecognition.alloc.init
    @speechRecognition.delegate = self
  end

  def recognition(speechRecognition, didGetRecognitionResult: result)
    @contentTextView.value += result.text
  end

  def viewDidLoad
    super
    performHousekeepingTasks
  end

  def performHousekeepingTasks
    navigationItem.title = 'New Story'
    view.backgroundColor = '#fff'.uicolor

    section = @form.sections[0]
    @titleTextField ||= section.rows[0]
    @contentTextView ||= section.rows[1]

    @gestureRecognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action: 'dismissKeyboard')
    self.tableView.addGestureRecognizer(@gestureRecognizer)

    navigationItem.leftBarButtonItem = createFontAwesomeButton(icon: 'remove', touchHandler: 'dismiss')
    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'microphone', touchHandler: 'recordContent')
  end

  def createStory
    dismissKeyboard
    attrs = @form.render
    Story.create(title: attrs['title'], content: attrs['content'], creation_date: Time.now)
    cdq.save

    CRToastManager.showNotificationWithOptions({
      'kCRToastTextKey' => 'Post saved',
      'kCRToastTextAlignmentKey' => NSTextAlignmentCenter,
      'kCRToastAnimationInTypeKey' => CRToastAnimationTypeGravity,
      'kCRToastAnimationOutTypeKey' => CRToastAnimationTypeGravity,
      'kCRToastAnimationInDirectionKey' => CRToastAnimationDirectionLeft,
      'kCRToastAnimationOutDirectionKey' => CRToastAnimationDirectionRight
    }, completionBlock: -> {
      dismiss
    })

    'StoryCreated'.post_notification
  end

  def reset
    @textView.text = ''
  end

  def dismiss
    dismissViewControllerAnimated(true, completion: nil)
  end

  def dismissKeyboard
    view.endEditing(true)
  end

  def recordContent
    @speechRecognition.listenAndRecognizeWithTimeout(SPEECH_TIMEOUT, error: nil)
  end

end