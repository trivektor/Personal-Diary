class Story < CDQManagedObject

  def creationTimeAgo
    creation_date.timeAgo
  end

end
