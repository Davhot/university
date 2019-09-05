class ActionView::Helpers::FormBuilder
  def error_messages_for(method, options = {})
    @template.render 'error_messages_for_attr', object: object, attr: method
  end
end
