class GPlusUser

  def initialize(gppsignin)
    @gppsignin = gppsignin
  end

  def user_id
    @gppsignin.userID
  end

  def email
    @gppsignin.userEmail
  end

  def googlePlusUser
    @gppsignin.googlePlusUser
  end

  def language
    @gppsignin.language
  end

end