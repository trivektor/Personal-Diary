class GPlusUser

  # References
  # https://code.google.com/p/google-api-objectivec-client/

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

  def display_name
    return unless google_plus_user
    google_plus_user.displayName
  end

  def profile_picture
    return unless google_plus_user
    google_plus_user.image.url
  end

  def language
    @gppsignin.language
  end

  def firebase_id
    "gplus-#{user_id}"
  end

end