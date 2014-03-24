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
  TEXTVIEW_FONT = 'HelveticaNeue-Light'.uifont(19)

  attr_accessor :firebase, :story, :form, :speechSDK, :textView,
                :speechRecognition, :titleTextField, :contentTextView

  def init
    setupSpeechRecognition
    self
  end

  def setupSpeechRecognition
    @speechSDK = NSClassFromString('iSpeechSDK').sharedSDK
    @speechSDK.APIKey = ISPEECH_API_KEY
  end

  def recognition(speechRecognition, didGetRecognitionResult: result)
    @jsBridge.send({recognized_text: result.text})
  end

  def viewDidLoad
    performHousekeepingTasks
    setupForm
  end

  def performHousekeepingTasks
    navigationItem.title = 'New Story'
    view.backgroundColor = '#fff'.uicolor
    navigationItem.leftBarButtonItem = createFontAwesomeButton(icon: 'remove', touchHandler: 'dismiss')
    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'ok-sign', touchHandler: 'createStory')
  end

  def setupForm
    # 216 is the height of the keyboard
    height = view.frame.size.height - 216
    @textView = UITextView.alloc.initWithFrame([[0, 0], [320, height]])
    @textView.delegate = self
    @textView.font = TEXTVIEW_FONT
    @textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
    view.addSubview(@textView)
    @textView.becomeFirstResponder
  end

  def setupJavascriptBridge
    @jsBridge = WebViewJavascriptBridge.bridgeForWebView(@webView, webViewDelegate: self, handler: lambda { |data, callback|
      if data[:phone_input]
        recordContent
      elsif data[:create_story]
        createStory(title: data[:title], content: data[:content])
        # controller = UINavigationController.alloc.initWithRootViewController(MapViewController.new)
        # controller.modalPresentationStyle = UIModalPresentationFormSheet
        # presentViewController(controller, animated: true, completion: nil)
      end
    })
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
    #@speechRecognition.listenAndRecognizeWithTimeout(SPEECH_TIMEOUT, error: nil)
    @speechRecognition.listen(nil)
  end

  # Gesture detection
  def canBecomeFirstResponder
    true
  end

  def gatherFormData
    @jsBridge.send(gather_form_data: true)
  end

  # Shake detection
  def motionEnded(motion, withEvent: event)
    if event.subtype == UIEventSubtypeMotionShake
      @jsBridge.send(clear_form: true)
    end
  end

end