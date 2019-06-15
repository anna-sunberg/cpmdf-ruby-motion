class NewTaskForm < UIView
  attr_accessor :submit_button, :input

  def self.build_form(y_offset)
    form = NewTaskForm.alloc.initWithFrame(CGRectMake(10, y_offset, 500, 300))
    form.build_input
    form.build_button

    form
  end

  def build_input
    @input = UITextField.alloc.initWithFrame([[20, 0], [325, 40]])
    @input.placeholder = 'Task'
    @input.setBorderStyle UITextBorderStyleRoundedRect

    addSubview @input
  end

  def build_button
    @submit_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @submit_button.frame = [[20, 50], [325, 40]]
    @submit_button.setTitle("Add", forState: UIControlStateNormal)

    addSubview @submit_button
  end
end