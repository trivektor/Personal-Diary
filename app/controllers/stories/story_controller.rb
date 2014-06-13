class StoryController < BaseController

  attr_accessor :story

  TEMPLATE = 'templates/story'

  def initWithStory(story)
    @story = story
    self
  end

  def viewDidLoad
    performHousekeepingTasks
    setupWebViewForm
  end

  def performHousekeepingTasks
    navigationItem.title = 'Story'
  end

  def setupWebViewForm
    @webView = createWebView
    view.addSubview(@webView)
    html = loadTemplate(TEMPLATE, @story.to_json)
    @webView.loadHTMLString(html, baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle.bundlePath))
  end

end

class NewStoryController < Formotion::FormController

  include UIViewControllerExtension

  SPEECH_TIMEOUT = 20
  TEMPLATE = 'templates/new_story'
  TEXTVIEW_FONT = 'HelveticaNeue-Light'.uifont(18)

  attr_accessor :firebase, :story

  def init
    @form = Formotion::Form.new(
      sections: [
        {
          title: 'Title',
          rows: [
            {
              key: 'title',
              type: 'string',
              font: {name: 'HelveticaNeue-Light', size: 18},
              text_alignment: 'left'
            }
          ]
        },
        {
          title: 'Content',
          rows: [
            {
              key: 'content',
              type: 'text',
              row_height: 300,
              font: {name: 'HelveticaNeue-Light', size: 18}
            }
          ]
        }
      ]
    )

    super.initWithForm(@form)
  end

  def setupSpeechRecognition
    @speechSDK = NSClassFromString('iSpeechSDK').sharedSDK
    @speechSDK.APIKey = ISPEECH_API_KEY
  end

  def recognition(speechRecognition, didGetRecognitionResult: result)
    @contentTextView.value = result.text.to_s
  end

  def viewDidLoad
    super
    @contentTextView = @form.row_for_index_path(NSIndexPath.indexPathForRow(0, inSection: 1))
    @titleTextField = @form.row_for_index_path(NSIndexPath.indexPathForRow(0, inSection: 0))

    @titleTextField.value = 'Untitled'
    performHousekeepingTasks
    createOptionsMenu
  end

  def performHousekeepingTasks
    setupSpeechRecognition
    navigationItem.title = 'New Story'
    view.backgroundColor = '#fff'.uicolor
    navigationItem.leftBarButtonItem = createFontAwesomeButton(icon: 'remove', touchHandler: 'dismiss')
    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'gear', touchHandler: 'toggleOptionsMenu')
  end

  def createOptionsMenu
    @recordItem = REMenuItem.alloc.initWithTitle('Record', subtitle: 'Speak instead of typing', image: nil, highlightedImage: nil, action: lambda do |item|
      recordContent
    end)
    @saveItem = REMenuItem.alloc.initWithTitle('Save', subtitle: 'Save your story', image: nil, highlightedImage: nil, action: lambda do |item|
      createStory
    end)
    @menu = REMenu.alloc.initWithItems([@recordItem, @saveItem])
  end

  def createStory
    showProgress
    attrs = @form.render

    BW::Location.get_once do |loc|
      location = CLLocation.alloc.initWithLatitude(loc.latitude, longitude: loc.longitude)

      geocoder = CLGeocoder.alloc.init

      geocoder.reverseGeocodeLocation(location, completionHandler: lambda { |placemarks, error|
        unless placemarks.empty?
          placemark = placemarks[0]
          attrs.merge!(postal_code: placemark.postalCode, state: placemark.administrativeArea, city: placemark.locality)
        end
        Story.create(attrs)
        hideProgress
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
      })
    end
  end

  def dismiss
    dismissViewControllerAnimated(true, completion: nil)
  end

  def dismissKeyboard
    view.endEditing(true)
  end

  def recordContent
    @speechRecognition = ISSpeechRecognition.alloc.init
    @speechRecognition.delegate = self
    @speechRecognition.listenAndRecognizeWithTimeout(SPEECH_TIMEOUT, error: nil)
    @speechRecognition.listen(nil)
  end

  def toggleOptionsMenu
    if @menu.isOpen
      @menu.close
    else
      @menu.showFromNavigationController(self.navigationController)
    end
  end

  # Gesture detection
  def canBecomeFirstResponder
    true
  end

  # Shake detection
  def motionEnded(motion, withEvent: event)
    if event.subtype == UIEventSubtypeMotionShake
      # TODO: implement
      @titleTextField.value = ''
      @contentTextView.value = ''
    end
  end

end