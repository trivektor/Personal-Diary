class CurrentUserManager

  def self.init_with_user(user)
    Dispatch.once { @user ||= user }
    @user
  end

  def self.shared_instance
    @user
  end

end