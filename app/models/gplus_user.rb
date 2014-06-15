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

  def google_plus_user
    @gppsignin.googlePlusUser
  end

  def language
    @gppsignin.language
  end

  def firebase_id
    "gplus-#{user_id}"
  end

end