class Task
  attr_reader :id, :text, :completed
  attr_accessor :text, :completed

  def initialize(dict)
    @id = dict['_id']
    @text = dict['text']
    @completed = dict['completed']
  end

end