class TaskListController < UIViewController
  def viewDidLoad
    super
    self.title = 'To-do app'
    self.view.backgroundColor = UIColor.whiteColor

    @tasks = []
    @filtered_tasks = []

    @searchBar = UISearchBar.alloc.initWithFrame(CGRectMake(0, 0, self.view.frame.size.width, 30))
    @searchBar.delegate = self
    @searchBar.showsCancelButton = true
    @searchBar.sizeToFit
    @searchBar.text = ''

    @table = UITableView.alloc.initWithFrame(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 100))
    @table.dataSource = @table.delegate = self
    @table.tableHeaderView = @searchBar
    view.addSubview @table

    @new_task_form = NewTaskForm.build_form(self.view.frame.size.height - 100)
    @new_task_form.submit_button.addTarget(self, action: "add_task", forControlEvents: UIControlEventTouchUpInside)
    view.addSubview @new_task_form

    load_tasks
  end

  def load_tasks
    api_client.fetch_tasks() do |json|
      @tasks = []
      json.each do |dict|
        @tasks << Task.new(dict)
      end

      @filtered_tasks = @tasks
      @table.reloadData
    end
  end

  def api_client
    @api_client ||= ApiClient.new
  end

  def add_task
    api_client.add_task(@new_task_form.input.text) do |result|
      if result['_id']
        @tasks << Task.new(result)
        @table.reloadData
        searchBarSearchButtonClicked(@searchBar)
      end
      @new_task_form.input.text = ''
    end
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @filtered_tasks.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    task = @filtered_tasks[indexPath.row]
    TaskCell.cellForTask(task, inTableView:tableView)
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    task = @filtered_tasks[indexPath.row]
    task.completed = true
    api_client.update_task(task) do |result|
      @table.reloadData
      searchBarSearchButtonClicked(@searchBar)
    end
  end

  def tableView(tableView, canEditRowAtIndexPath:indexPath)
    true
  end

  def tableView(tableView, commitEditingStyle:editinyStyle, forRowAtIndexPath: indexPath)
    task = @filtered_tasks[indexPath.row]
    api_client.delete_task(task) do |result|
      @tasks.delete(task)
      @table.reloadData
      searchBarSearchButtonClicked(@searchBar)
    end
  end

  def reloadRowForTask(task)
    row = @filtered_tasks.index(task)
    if row
      view.reloadRowsAtIndexPaths([NSIndexPath.indexPathForRow(row, inSection:0)], withRowAnimation:false)
    end
  end

  def searchBarSearchButtonClicked(searchBar)
    query = searchBar.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)

    @filtered_tasks = []
    @tasks.each do |task|
      if task.text.downcase().include? query.downcase()
        @filtered_tasks << task
      end
    end

    @table.reloadData
  end

  def searchBarCancelButtonClicked(searchBar)
    searchBar.resignFirstResponder
    @filtered_tasks = @tasks
    @table.reloadData
  end

end