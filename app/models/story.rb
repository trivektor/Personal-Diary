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

  def creation_time_ago
    Time.at(timestamp).strftime('%Y-%m-%d').to_s
  end

  def location
    @attrs.values_at('city', 'state').compact.join(', ')
  end

  def time_and_location
    "#{creation_time_ago} near #{location}"
  end

  def destroy
    FirebaseManager.shared_instance.childByAppendingPath(key).clear!
  end

  def to_json
    {
      'title' => title,
      'content' => content,
      'creation_date' => creation_time_ago
    }
  end

  def self.create(attrs={})
    unless attrs[:title].to_s.length > 0
      attrs[:title] = "Story on #{Time.now.strftime('%B %d %Y')}"
    end
    FirebaseManager.shared_instance.childByAutoId.set(attrs.merge(timestamp: Time.now.to_i))
  end

end