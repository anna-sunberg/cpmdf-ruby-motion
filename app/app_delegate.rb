class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @task_controller = TaskListController.alloc.init

    @navigation_controller = UINavigationController.alloc.init
    @navigation_controller.pushViewController(@task_controller, animated:false)

    #@window.rootViewController = TaskListController.alloc.initWithStyle(UITableViewStylePlain)
    @window.rootViewController = @navigation_controller
    @window.makeKeyAndVisible

    true
  end
end
