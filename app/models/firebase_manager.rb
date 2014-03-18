class FirebaseManager

  def self.initWithUser(user)
    Dispatch.once do
      @firebase ||= Firebase.new(FIREBASE_URL).childByAppendingPath(user.firebaseId)
    end

    @firebase
  end

  def self.sharedInstance
    @firebase
  end

end