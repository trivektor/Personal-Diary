class FirebaseManager

  def self.initWithUser(user)
    Dispatch.once do
      @firebase ||= Firebase.alloc
        .initWithUrl(FIREBASE_URL)
        .childByAppendingPath(user.firebaseId)
    end

    @firebase
  end

  def self.sharedInstance
    @firebase
  end

end