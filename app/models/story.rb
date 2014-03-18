class Story

  attr_reader :key, :attrs

  def initialize(key, attrs={})
    @key = key
    @attrs = attrs
  end

  def title
    @attrs['title']
  end

  def content
    @attrs['content']
  end

  def timestamp
    @attrs['timestamp']
  end

  def creationTimeAgo
    NSDate.dateWithTimeIntervalSince1970(timestamp).timeAgo
  end

  def destroy
    FirebaseManager.sharedInstance.childByAppendingPath(key).clear!
  end

  def to_json
    {
      'title' => title,
      'content' => content,
      'creation_date' => creationTimeAgo
    }
  end

  def self.create(attrs={})
    unless attrs[:title].to_s.length > 0
      attrs[:title] = "Story on #{Time.now.strftime('%B %d %Y')}"
    end
    FirebaseManager.sharedInstance.childByAutoId.set(attrs.merge(timestamp: Time.now.to_i))
  end

end