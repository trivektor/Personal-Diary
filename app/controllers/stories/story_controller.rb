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

  attr_accessor :firebase, :story, :form, :speechSDK, 
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
    setupWebViewForm
    setupJavascriptBridge
  end

  def performHousekeepingTasks
    navigationItem.title = 'New Story'
    view.backgroundColor = '#fff'.uicolor
    navigationItem.leftBarButtonItem = createFontAwesomeButton(icon: 'remove', touchHandler: 'dismiss')
    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'microphone', touchHandler: 'recordContent')
  end

  def setupWebViewForm
    @webView = createWebView
    view.addSubview(@webView)
    html = loadTemplate(TEMPLATE)
    @webView.loadHTMLString(html, baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle.bundlePath))
  end

  def setupJavascriptBridge
    @jsBridge = WebViewJavascriptBridge.bridgeForWebView(@webView, webViewDelegate: self, handler: lambda { |data, callback|
      createStory(data)
    })
  end

  def createStory(attrs={})
    Story.create(attrs)

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

  # Shake detection
  def motionEnded(motion, withEvent: event)
    if event.subtype == UIEventSubtypeMotionShake
      @jsBridge.send(clear_form: true)
    end
  end

end