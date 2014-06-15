class FirebaseManager

  def self.init_with_user(user)
    Dispatch.once do
      @firebase_instance ||= Firebase.new(FIREBASE_URL)[user.firebase_id]
    end

    shared_instance
  end

  def self.shared_instance
    @firebase_instance
  end

end