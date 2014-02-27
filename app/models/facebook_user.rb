class FacebookUser

  attr_accessor :data

  def initialize(data={})
    @data = data
  end

  def fid
    @data[:id]
  end

  def username
    @data[:username]
  end

  def first_name
    @data[:first_name]
  end

  def last_name
    @data[:last_name]
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def location
    @data[:location][:name]
  end

  def profile_picture
    "https://graph.facebook.com/#{fid}/picture"
  end

end