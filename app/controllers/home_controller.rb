class HomeController < UIViewController

  attr_accessor :facebook

  def viewDidLoad
    super
    navigationItem.title = 'Home'
    @facebook = Facebook.alloc.initWithAppId(FACEBOOK_KEY, andDelegate:self)

    defaults = NSUserDefaults.standardUserDefaults
    puts defaults.objectForKey("FBAccessToken")
    puts defaults.objectForKey("FBExpirationDate")

    if defaults.objectForKey("FBAccessToken") && defaults.objectForKey("FBExpirationDate")
      @facebook.accessToken = defaults.objectForKey("FBAccessToken")
      @facebook.expirationDate = defaults.objectForKey("FBExpirationDate")
    end

    if @facebook.isSessionValid
      puts(@facebook.accessToken)
      puts(@facebook.expirationDate)
      puts("Login succeeded!")
    else
      puts('relogin')
      @facebook.authorize nil
    end

  end

  def fbDidLogin
    puts 'Facebook did login'
    defaults = NSUserDefaults.standardUserDefaults
    puts @facebook.accessToken
    #puts @facebook.expirationDate

    defaults.setObject(@facebook.accessToken, forKey:'FBAccessToken')
    defaults.setObject(@facebook.expirationDate, forKey:'FBExpirationDate')
    NSUserDefaults.standardUserDefaults.synchronize

    puts "Login succeeded!"
  end

  def fbDidNotLogin
    puts "Login failed!"
  end

end