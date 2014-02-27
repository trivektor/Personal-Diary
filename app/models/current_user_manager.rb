class CurrentUserManager

  def self.initWithUser(user)
    Dispatch.once { @user ||= user }
    @user
  end

  def self.sharedInstance
    @user
  end

end