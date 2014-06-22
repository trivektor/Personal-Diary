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
    createBarButtonItems
  end

  def createBarButtonItems
    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'pencil', touchHandler: 'editStory')
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

  def editStory
    controller = EditStoryController.new
    controller.story = @story
    navigationController.pushViewController(controller, animated: true)
  end

end

class StoryFormController < Formotion::FormController

  def init
    @form = Formotion::Form.new(
      sections: [
        {
          title: 'Title',
          rows: [
            {
              key: :title,
              type: :string,
              font: {name: APP_FONT_SEMI_BOLD, size: 18},
              text_alignment: 'left',
              placeholder: 'Title of Your Story',
              auto_correction: :no
            }
          ]
        },
        {
          title: 'Content',
          rows: [
            {
              key: :content,
              type: :text,
              row_height: 300,
              font: {name: APP_FONT_SEMI_BOLD, size: 18},
              placeholder: 'Content of Your Story',
              auto_correction: :no
            }
          ]
        }
      ]
    )

    super.initWithForm(@form)
  end

end

class EditStoryController < StoryFormController

  attr_accessor :firebase, :story

  def init
    super
    self
  end

  def viewDidLoad
    super
    navigationItem.title = 'Edit Story'
    view.backgroundColor = '#fff'.uicolor
  end

end

class NewStoryController < StoryFormController

  include UIViewControllerExtension

  SPEECH_TIMEOUT = 20
  TEMPLATE = 'templates/new_story'

  attr_accessor :firebase, :story

  def init
    super
    self
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

    performHousekeepingTasks
    create_options_menu
  end

  def performHousekeepingTasks
    setupSpeechRecognition
    navigationItem.title = 'New Story'
    view.backgroundColor = '#fff'.uicolor
    navigationItem.leftBarButtonItem = createFontAwesomeButton(icon: 'remove', touchHandler: 'dismiss')
    navigationItem.rightBarButtonItem = createFontAwesomeButton(icon: 'gear', touchHandler: 'toggleOptionsMenu')
  end

  def create_options_menu
    title_font = UIFont.fontWithName(APP_FONT_SEMI_BOLD, size: 22)
    subtitle_font = UIFont.fontWithName(APP_FONT_SEMI_BOLD, size: 18)

    @recordItem = REMenuItem.alloc.initWithTitle('Record', subtitle: 'Speak instead of typing', image: nil, highlightedImage: nil, action: lambda do |item|
      dismissKeyboard
      recordContent
    end)
    @recordItem.font = title_font
    @recordItem.subtitleFont = subtitle_font

    @saveItem = REMenuItem.alloc.initWithTitle('Save', subtitle: 'Save your story', image: nil, highlightedImage: nil, action: lambda do |item|
      dismissKeyboard
      create_story
    end)
    @saveItem.font = title_font
    @saveItem.subtitleFont = subtitle_font

    @menu = REMenu.alloc.initWithItems([@recordItem, @saveItem])
  end

  def create_story
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