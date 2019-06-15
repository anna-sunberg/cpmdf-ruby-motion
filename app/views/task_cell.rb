class TaskCell < UITableViewCell
  CellID = 'CellIdentifier'
  MessageFontSize = 14

  def self.cellForTask(task, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier(TaskCell::CellID) || TaskCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)
    cell.fillWithTask(task, inTableView:tableView)
    cell
  end

  def initWithStyle(style, reuseIdentifier:cellid)
    if super
      self.textLabel.numberOfLines = 0
      self.textLabel.font = UIFont.systemFontOfSize(MessageFontSize)
    end
    self
  end

  def fillWithTask(task, inTableView:tableView)
    self.textLabel.text = task.text
    if task.completed
      self.textLabel.textColor = UIColor.colorWithRed(0.28, green:0.54, blue:0.08, alpha:1.0)
    end
  end
end