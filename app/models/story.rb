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

end