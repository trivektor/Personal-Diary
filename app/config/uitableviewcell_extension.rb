class UITableViewCell
  def self.reuseIdentifier
    self.class.to_s
  end

  def defineAccessoryType(type=UITableViewCellAccessoryDisclosureIndicator)
    self.accessoryType = type
  end
end
