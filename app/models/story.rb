class Story < CDQManagedObject

  def creationTimeAgo
    NSDate.dateWithTimeIntervalSince1970(timestamp).timeAgo
  end

end
