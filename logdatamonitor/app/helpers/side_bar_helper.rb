module SideBarHelper
  def side_bar_items(ru)
    result = []
    result << {
      :name => 'На главную',
      :icon => 'list',
      :controller => :hot_catch_apps,
      :action => :index,
      :class => "long"
    }
    # result << {
    #   :name => 'Администрирование',
    #   :icon => 'users',
    #   :children => [
    #   {:name => 'Пользователи',
    #    :controller => :users, :action => :index,
    #    :icon => 'users',
    #    :class => 'long'},
    #   {:name => 'Добавление',
    #    :controller => :users, :action => :new,
    #    :icon => 'user-plus'},
    #   {:name => 'Роли',
    #    :controller => :roles, :action => :index,
    #    :icon => 'align-center',
    #    :class => 'long'},
    # ]} if is_admin?
    # result << {
    #   :name => 'Экскурсионные туры',
    #   :icon => 'wpexplorer',
    #   :children => [
    #   {:name => 'Туры',
    #    :controller => :tours, :action => :index,
    #    :icon => 'globe',
    #    :class => 'long'},
    #    {:name => 'Экскурсии',
    #     :controller => :excursions, :action => :index,
    #     :icon => 'binoculars',
    #     :class => 'long'}
    # ]}
    result
  end

  def is_open?(ctr, act)
    case ctr.to_s
    when 'users', 'roles', 'tours', 'excursions'
      ctr.to_s == controller_name.to_s
    else
      false
    end
  end
end
