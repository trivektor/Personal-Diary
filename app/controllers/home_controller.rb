class HomeController < UIViewController

  def viewDidLoad
    super
    navigationItem.title = 'Home'

    SimpleAuth.authorize('facebook-web', completion: lambda do |response, error|
      puts response.inspect
      puts error.inspect
    end)
  end

end