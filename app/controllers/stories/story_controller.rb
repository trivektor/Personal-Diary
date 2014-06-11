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

class NewStoryController < BaseController

  include UIViewControllerExtension

  SPEECH_TIMEOUT = 20
  TEMPLATE = 'templates/new_story'
  TEXTVIEW_FONT = 'HelveticaNeue-Light'.uifont(18)

  attr_accessor :firebase, :story, :form, :speechSDK, :textView,
                :speechRecognition, :titleTextField, :contentTextView, :menu

  def init
    setupSpeechRecognition
    self
  end

  def setupSpeechRecognition
    @speechSDK = NSClassFromString('iSpeechSDK').sharedSDK
    @speechSDK.APIKey = ISPEECH_API_KEY
  end

  def recognition(speechRecognition, didGetRecognitionResult: result)
    @textView.insertText(result.text.to_s)
  end

  def viewDidLoad
    performHousekeepingTasks
    setupForm
    createOptionsMenu
  end

  def performHousekeepingTasks
    navigationItem.title = 'New Story'
    view.backgroundColor = '#fff'.uicolor
    navigationItem.leftBarButtonItem = createFontAwesomeButton(icon: 'remove', touchHandler: 'dismiss')
    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'gear', touchHandler: 'toggleOptionsMenu')
  end

  def setupForm
    # 216 is the height of the keyboard
    height = view.frame.size.height - 216
    @textView = UITextView.alloc.initWithFrame([[0, 0], [320, height]])
    @textView.delegate = self
    @textView.font = TEXTVIEW_FONT
    @textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
    @textView.tintColor = NEPHRITIS_COLOR
    view.addSubview(@textView)
    @textView.becomeFirstResponder
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
    attrs = {content: @textView.text}

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
      @jsBridge.send(clear_form: true)
    end
  end

end