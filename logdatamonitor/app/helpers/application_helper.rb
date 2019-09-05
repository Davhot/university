module ApplicationHelper
  def full_title(page_title)
    base_title = "Hot Catch"
    page_title.empty? ? base_title : "#{base_title} | #{page_title}"
  end

  def breadcrumb_tag(&block)
    render 'breadcrumb', block: capture(&block)
  end

  ROLE_FOR_METHODS = ['admin', 'operator']

  # Редирект, если ни одна роль из массива не подходит
  def redirect_if_not_one_of_role_in (mas)
    bool = false
    mas.each{|x| bool ||= @current_role_user.try("is_#{x}?")}
    unless bool
      redirect_to(ip_path(
          :bad_action_name => action_name,
          :bad_controller_name => controller_name,
          :bad_user_role => @current_role_user.try(:id)))
    end
  end

  ROLE_FOR_METHODS.each do |rname|
    define_method "is_#{rname}?" do
      @current_role_user.try("is_#{rname}?")
    end
  end
end
