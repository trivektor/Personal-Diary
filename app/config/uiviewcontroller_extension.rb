module UIViewControllerExtension

  def createTable(options={})
    table = UITableView.alloc.initWithFrame(
      options[:frame] || self.view.bounds,
      style: options[:style] || UITableViewStylePlain
    )

    table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    table.delegate = self
    table.dataSource = self

    if options[:scroll_enabled].nil?
      table.setScrollEnabled(true)
    else
      table.setScrollEnabled(options[:scroll_enabled])
    end

    unless options[:cell].nil?
      table.registerClass(options[:cell], forCellReuseIdentifier: options[:cell].reuseIdentifier)
    end

    table.backgroundView = nil
    table.backgroundColor = options[:background_color] if options[:background_color]
    table.separatorColor = options[:separator_color] if options[:separator_color]
    table
  end

  def createWebView(options={})
    webView = UIWebView.alloc.initWithFrame(options[:frame] || self.view.bounds)
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    webView.backgroundColor = options[:background_color] || '#fff'.uicolor
    webView.delegate = self
    webView
  end

  def createFontAwesomeButton(options={})
    btn = UIBarButtonItem.titled(FontAwesome.icon(options[:icon])) do
      self.send(options[:touchHandler])
    end

    btn.setTitleTextAttributes({
      UITextAttributeFont => FontAwesome.fontWithSize(options[:size] || 20),
      UITextAttributeTextColor => (options[:color] || NAVBAR_FONT_COLOR).uicolor
    }, forState: UIControlStateNormal)
  end

  def createOptionsMenu(items, options={})
    optionsMenu = REMenu.alloc.initWithItems(items)
    optionsMenu.font = options[:font] || 'HelveticaNeue-Thin'.uifont(16)
    optionsMenu.borderWidth = 0
    optionsMenu.backgroundColor = options[:background_color] || '#333'.uicolor
    optionsMenu.textColor = options[:text_color] || '#fff'.uicolor
    optionsMenu.separatorColor = options[:separator_color] || '#fff'.uicolor(0.2)
    optionsMenu.separatorHeight = options[:separator_height] || 0.5
    optionsMenu
  end

  def loadTemplate(path, data={}, type='mustache')
    file = NSBundle.mainBundle.pathForResource(path, ofType: type)
    html = NSString.stringWithContentsOfFile(file, encoding: NSUTF8StringEncoding, error: nil)
    GRMustacheTemplate.renderObject(NSDictionary.dictionaryWithDictionary(data), fromString: html, error: nil)
  end

  def showProgress
    unless @progressIndicator
      screenBounds = UIScreen.mainScreen.bounds
      screenWidth = CGRectGetWidth(screenBounds)
      @progressIndicator = RTSpinKitView.alloc.initWithStyle(RTSpinKitViewStyleBounce)
      @progressIndicator.center = CGPointMake(CGRectGetMidX(screenBounds), CGRectGetMidY(screenBounds))
      @progressIndicator.color = SPINKIT_COLOR
      view.addSubview(@progressIndicator)
    end
    @progressIndicator.startAnimating
  end

  def hideProgress
    @progressIndicator.stopAnimating
  end

end