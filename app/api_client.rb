class ApiClient
  def initialize
    url = "https://rocky-beach-17461.herokuapp.com"
    @client = AFMotion::Client.build(url) do
      header "Accept", "application/json"
      header "Authorization", "Basic YW5uYTp3ZXJlLWtlcHQtZmlndXJl"

      response_serializer :json
    end
  end

  def fetch_tasks(&block)
    @client.get("tasks") do |result|
      block.call(result.object)
    end
  end

  def add_task(text, &block)
    @client.post("tasks", text: text, completed: false) do |result|
      block.call(result.object)
    end
  end

  def update_task(task, &block)
    @client.put("tasks/#{task.id}", text: task.text, completed: task.completed) do |result|
      block.call(result.object)
    end
  end

  def delete_task(task, &block)
    @client.delete("tasks/#{task.id}") do |result|
      block.call(result.object)
    end
  end
end
