# TODO: рефакторинг
# 1. Вынести методы в модели
# 2. Сделать локализацию дат в locales/
# 3. Добавить 3 контроллера, унаследованные от текущего: 1. Nginx 2. Rails 3. System и вынести методы туда
# 4. Общие методы вынести в даный контроллер
# TODO: ускорение:
# Сделать модели за час и день для System и накапливать в них значения
# TODO: доделать
# 1. Фильтры на Rails график
# 2. Показ кусок Nginx лога по IP или посетителю (сейчас все IP за указанный период)

class HotCatchAppsController < ApplicationController
  # TODO: разбить на 3 контроллера: логи Rails, Nginx и сервера
  before_action :set_hot_catch_app, except: [:index]

  before_action -> {redirect_if_not_one_of_role_in ["admin"]}

  include FormatDates

  def show_all_graphs
    gon.all_graphs_path = load_all_graphs_hot_catch_app_path(@hot_catch_app)
  end

  # TODO: SystemMetric данные в процентах
  def load_all_graphs
    @step = params["all_graphs_step"].present? ? params["all_graphs_step"] : "day"
    @from = params["all_graphs_from"].present? ?
      DateTime.strptime(params["all_graphs_from"], I18n.t("time.formats.show_date.#{@step}")) : nil
    @to = params["all_graphs_to"].present? ?
      DateTime.strptime(params["all_graphs_to"], I18n.t("time.formats.show_date.#{@step}")) : nil

    @network_links, @network_x_y = choose_networks_for_integrate_graph(@step)
      .get_data_graph(@hot_catch_app, @step, @from, @to) # Networks
    @x_main_metric, @y_main_metric = choose_system_metric_for_integrate_graph(@step)
      .get_data_graph(@hot_catch_app, @step, @from, @to) # MainMetrics
    @x_nginx, @y_nginx = MainHotCatchLog.get_nginx_data_graph(@hot_catch_app, @step, @from, @to) # Nginx
    @x_rails, @y_rails = UserRequest.get_data_graph(@hot_catch_app, @step, @from, @to) # Rails

    # Максимальные значения
    @max_values = {}
    @network_x_y.each_with_index{|x,i| @max_values[x[0]] = x[1..-1].max if i % 3 != 2}
    @y_main_metric.each{|x| @max_values[x[0]] = x[1..-1].max}
    [@y_nginx, @y_rails].each{|x| @max_values[x[0]] = x[1..-1].max}

    @links = @network_links.dup
    @graph_arrays = @network_x_y.dup

    @y_main_metric.each{|x| @links << [x[0], @x_main_metric[0]]; @graph_arrays << x}
    @graph_arrays << @x_main_metric
    @links << [@y_nginx[0], @x_nginx[0]]; @graph_arrays << @x_nginx; @graph_arrays << @y_nginx
    @links << [@y_rails[0], @x_rails[0]]; @graph_arrays << @x_rails; @graph_arrays << @y_rails

    # Перевод данных в проценты
    @percent_graph_arrays = []
    @graph_arrays.each do |x|
      if x[0] != "процессор" && @max_values.has_key?(x[0])
        @percent_graph_arrays << [x[0]] + x[1..-1].map{|y| y/@max_values[x[0]].to_f * 100}
      else
        @percent_graph_arrays << x
      end
    end

    render :load_all_graphs, :layout => false
  end
  # ============================================================================
  # Ajax получение данных лога по клику на точку графика
  def nginx_logs
    parser = ParseNginx.new
    if params["nginx-date"].present?
      parser.parse_file_for_date("log/apps/#{@hot_catch_app.name.downcase}-nginx.access.log", params["nginx-date"])
      render :json => { :status => true, :nginx_logs => parser.data.map{|x| {log: x}} }
    else
      render :json => { :status => true, :nginx_logs => {log: "Нет данных"} }
    end
  end

  # Ajax подгрузка графика
  def load_nginx_graph
    parser = ParseNginx.new
    parser.parse_all_data("log/apps/#{@hot_catch_app.name.downcase}-nginx.access.log")
    @data = parser.data
    @ips = @data.map{|x| x[0]}.uniq
    @visitors = @data.map{|x| [x[0], "#{x[0]}|#{x[2]}"]}.uniq

    if params["nginx_graph_form_type"].present?
      @cur_ip = params["nginx_graph_form_ip"] if params["nginx_graph_form_ip"].present?
      @cur_visitor = params["nginx_graph_form_visitor"] if params["nginx_graph_form_visitor"].present?
      if params["nginx_graph_form_type"] == "ip" && params["nginx_graph_form_ip"].present?
        @data = @data.select{|x| x[0] == params["nginx_graph_form_ip"]}
      elsif params["nginx_graph_form_type"] == "visitor" && params["nginx_graph_form_visitor"].present?
        ip, visitor_info = params["nginx_graph_form_visitor"].split("|")
        @data = @data.select{|x| x[0] == ip && x[2] == visitor_info}
      end
    end
    @min_date = l @data.first[1]
    @max_date = l @data.last[1]
    # Берём логи за определённый промежуток времени
    if params["nginx_graph_form_from"].present?
      @begin_date = DateTime.strptime(params["nginx_graph_form_from"], format_show_datetime("minute"))
      @data = @data.select{|x| x[1] > @begin_date }
    end
    if params["nginx_graph_form_to"].present?
      @end_date = DateTime.strptime(params["nginx_graph_form_to"], format_show_datetime("minute"))
      @data = @data.select{|x| x[1] < @end_date }
    end

    @nginx_logs_path = nginx_logs_hot_catch_app_url(@hot_catch_app)
    @nginx_graph_form_step = params["nginx_graph_form_step"].present? ? params["nginx_graph_form_step"] : "hour"

    @moment_format = format_moment(@nginx_graph_form_step)
    @parse_c3_date_format = format_c3_date(@nginx_graph_form_step)
    @show_datetime_format = format_show_datetime(@nginx_graph_form_step)

    @graphic_stats = @data.map{|x| x[1].strftime(@parse_c3_date_format)}.group_by{|e| e}.map{|k, v| [k, v.length]}
    @graph_data_x = @graphic_stats.map{|x| x[0]} # DATE
    @graph_data_y = @graphic_stats.map{|x| x[1]} # COUNT REQUESTS

    if @begin_date.present? && @end_date.present? && @begin_date > @end_date
      @error_date = true
    else
      @begin_date = (@begin_date.blank? ? DateTime.strptime(@graph_data_x.first, format_c3_date(@nginx_graph_form_step)) \
        : @begin_date).strftime(format_show_datetime("minute"))

      @end_date = (@end_date.blank? ? DateTime.strptime(@graph_data_x.last, format_c3_date(@nginx_graph_form_step)) \
        : @end_date).strftime(format_show_datetime("minute"))
    end

    render :load_nginx_graph, :layout => false
  end

  def show_nginx_graph
    gon.nginx_load_graph_path = load_nginx_graph_hot_catch_app_url(@hot_catch_app)
  end

  def show_nginx_statistic
    o_file = "log/apps/#{@hot_catch_app.name.downcase}-report.json"
    # o_file = "log/apps/dummy-report2.json"
    if File.exist?(o_file) && File.open(o_file, 'r'){|file| file.read}.present?
      @data = JSON.parse(File.open(o_file, 'r'){|file| file.read})
      @general = @data["general"]
      @visitors = @data["visitors"]
      @requests = @data["requests"]
      @static_requests = @data["static_requests"]
      @hosts = @data["hosts"]
      @os = @data["os"]
      @browsers = @data["browsers"]
      @visit_time = @data["visit_time"]
      @status_codes = @data["status_codes"]
      @geolocation = @data["geolocation"]
    else
      flash[:danger] = "Статистика не найдена"
      redirect_to hot_catch_apps_path
    end
  end
  # ============================================================================

  # ============================================================================
  def load_network_graph
    @min_date = Network.where(hot_catch_app_id: @hot_catch_app.id)
      .order(:get_time).first.get_time.change(:offset => DateTime.current.zone).utc
    @max_date = Network.where(hot_catch_app_id: @hot_catch_app.id)
      .order(:get_time).last.get_time.change(:offset => DateTime.current.zone).utc
    # Настройки ============
    if params[:network_metric_form_step].blank?
      @step_metric = "day"
    else
      @step_metric = params[:network_metric_form_step]
    end

    if params[:network_metric_graph_form_from].present?
      @begin_date = DateTime.strptime(params[:network_metric_graph_form_from],
        format_show_datetime("minute")).change(:offset => DateTime.current.zone).utc
    else
      @begin_date = @min_date
    end

    if params[:network_metric_graph_form_to].present?
      @end_date = DateTime.strptime(params[:network_metric_graph_form_to],
        format_show_datetime("minute")).change(:offset => DateTime.current.zone).utc
    else
      @end_date = @max_date
    end
    # ======================

    case @step_metric
    when "month"
      @format_date = ("%m.%Y")
    when "day"
      @format_date = ("%D")
    when "hour"
      @format_date = ("%D %H")
      @show_time = true
    else
      @format_date = ("%D %H:%M")
      @show_time = true
    end

    @name_networks = @hot_catch_app.network_interfaces

    @moment_format = format_moment(@step_metric)
    @parse_c3_date_format = format_c3_date(@step_metric)
    @show_datetime_format = format_show_datetime(@step_metric)


    @x = []
    @y = []

    @name_networks.each_with_index do |name, index|
      @networks = []
      networks = choose_network_metric(@step_metric, name).where(
        "get_time >= ? AND get_time <= ?",
        @begin_date.strftime(format_c3_date("second")),
        @end_date.strftime(format_c3_date("second"))
      ).order(:get_time)
      @y << ["#{name}: входящий трафик"]
      @y << ["#{name}: исходящий трафик"]
      @y << ["x#{index + 1}"]
      @x << [@y[-2][0], @y[-1][0]]
      @x << [@y[-3][0], @y[-1][0]]

      networks.each do |network|
        @y[-1] << network.get_time.strftime(@parse_c3_date_format)
        @y[-2] << network.bytes_out
        @y[-3] << network.bytes_in
      end
    end
    # ОТОБРАЖАЕМ @x и @y
    render :load_network_graph, :layout => false
  end


  def load_main_metric_graph
    @min_date = @hot_catch_app.system_metrics.order(:get_time).first
      .get_time.change(:offset => DateTime.current.zone).utc
    @max_date = @hot_catch_app.system_metrics.order(:get_time).last
      .get_time.change(:offset => DateTime.current.zone).utc
    # Настройки ============
    if params[:main_metric_form_step].blank?
      @step_metric = "day"
      @show_time = true
    else
      @step_metric = params[:main_metric_form_step]
    end

    if params[:main_metric_graph_form_from].present?
      @begin_date = DateTime.strptime(params[:main_metric_graph_form_from],
        format_show_datetime("minute")).change(:offset => DateTime.current.zone)
    else
      @begin_date = @min_date
    end

    if params[:main_metric_graph_form_to].present?
      @end_date = DateTime.strptime(params[:main_metric_graph_form_to],
        format_show_datetime("minute")).change(:offset => DateTime.current.zone)
    else
      @end_date = @max_date
    end
    # ======================

    case @step_metric
    when "month"
      @format_date = ("%m.%Y")
    when "day"
      @format_date = ("%D")
    when "hour"
      @format_date = ("%D %H")
      @show_time = true
    else
      @format_date = ("%D %H:%M")
      @show_time = true
    end

    @moment_format = format_moment(@step_metric)
    @parse_c3_date_format = format_c3_date(@step_metric)
    @show_datetime_format = format_show_datetime(@step_metric)

    @all_metrics = @hot_catch_app.system_metrics.where(
      "get_time >= ? AND get_time <= ?",
      @begin_date.strftime(format_c3_date("second")),
      @end_date.strftime(format_c3_date("second"))
    ).order(:get_time)

    @x = ["x1"]
    @y = [["процессор"], ["использование памяти"],
      ["файл подкачки"], ["используемые дескрипторы"]]

    @all_metrics = choose_system_metric(@step_metric).where(
      "get_time >= ? AND get_time <= ?",
      @begin_date.strftime(format_c3_date("second")),
      @end_date.strftime(format_c3_date("second"))
    ).order(:get_time)

    @all_metrics.each do |metric|
      @x << metric.get_time.strftime(@parse_c3_date_format)
      @y[0] << metric.cpu_average
      @y[1] << metric.memory_used
      @y[2] << metric.swap_used
      @y[3] << metric.descriptors_used
    end
    # ОТОБРАЖАЕМ @x и @y
    render :load_main_metric_graph, :layout => false
  end

  def show_server_graph
    gon.network_load_graph_path = load_network_graph_hot_catch_app_url(@hot_catch_app)
    gon.main_metric_load_graph_path = load_main_metric_graph_hot_catch_app_url(@hot_catch_app)
  end

  def show_server_statistic
    if @hot_catch_app.system_metrics.blank?
      flash[:danger] = "Статистика не найдена"
      redirect_to hot_catch_apps_path
    else
      gon.server_main_staticstic_path = get_ajax_table_main_metric_hot_catch_app_url(@hot_catch_app)
      gon.server_network_staticstic_path = get_ajax_table_network_metric_hot_catch_app_url(@hot_catch_app)
      @disks = @hot_catch_app.disks

      @network_names = @hot_catch_app.network_interfaces

      @rows_main_metric = 4
      @rows_network_metric = 5
    end
  end

  # Ajax подгрузка сетевых интерфейсов
  def get_ajax_table_network_metric
    @min_date = Network.where(hot_catch_app_id: @hot_catch_app.id)
      .order(:get_time).first.get_time.change(:offset => DateTime.current.zone)
    @max_date = Network.where(hot_catch_app_id: @hot_catch_app.id)
      .order(:get_time).last.get_time.change(:offset => DateTime.current.zone)
    # Настройки ============
    if params[:network_metric_form_step].blank?
      @step_metric = "day"
      # @show_time = true
    else
      @step_metric = params[:network_metric_form_step]
    end

    if params[:network_metric_table_form_from].present?
      @begin_date = DateTime.strptime(params[:network_metric_table_form_from],
        format_show_datetime("minute")).change(:offset => DateTime.current.zone)
    else
      @begin_date = @min_date
    end

    if params[:network_metric_table_form_to].present?
      @end_date = DateTime.strptime(params[:network_metric_table_form_to],
        format_show_datetime("minute")).change(:offset => DateTime.current.zone)
    else
      @end_date = @max_date
    end
    # ======================

    case @step_metric
    when "month"
      @format_date = ("%m.%Y")
    when "day"
      @format_date = ("%D")
    when "hour"
      @format_date = ("%D %H")
      @show_time = true
    else
      @format_date = ("%D %H:%M")
      @show_time = true
    end

    @name_networks = @hot_catch_app.network_interfaces
    @name_networks.map!{|name| [name]}

    @name_networks.each_with_index do |name, index|
      @networks = []
      networks = choose_network_metric(@step_metric, name).where(
        "get_time >= ? AND get_time <= ?",
        @begin_date.strftime(format_c3_date("second")),
        @end_date.strftime(format_c3_date("second"))
      ).order(:get_time)
      networks.each{|network| @networks << [network.get_time, network.bytes_in, network.bytes_out]}
      @name_networks[index] << @networks.last(150)
    end

    render :get_ajax_table_network_metric, :layout => false
  end

  # Ajax подгрузка нагрузки на систему
  def get_ajax_table_main_metric
    @main_metric = @hot_catch_app.main_metric
    @min_time = @hot_catch_app.system_metrics.order(:get_time).first.get_time.change(:offset => DateTime.current.zone)
    @max_time = @hot_catch_app.system_metrics.order(:get_time).last.get_time.change(:offset => DateTime.current.zone)
    # Настройки ============
    if params[:main_metric_form_step].blank?
      @step_metric = "day"
      # @show_time = true
      @show_processor = true
      @show_memory = true
      @show_swap = true
      @show_descriptors = true
    else
      @show_processor = params[:main_metric_form_row_processor].present?
      @show_memory = params[:main_metric_form_row_memory].present?
      @show_swap = params[:main_metric_form_row_swap].present?
      @show_descriptors = params[:main_metric_form_row_descriptors].present?
      @step_metric = params[:main_metric_form_step]
    end

    if params[:main_metric_table_form_from].present?
      @begin_date = DateTime.strptime(params[:main_metric_table_form_from],
        format_show_datetime("minute")).change(:offset => DateTime.current.zone)
    else
      @begin_date = @min_time
    end

    if params[:main_metric_table_form_to].present?
      @end_date = DateTime.strptime(params[:main_metric_table_form_to],
        format_show_datetime("minute")).change(:offset => DateTime.current.zone)
    else
      @end_date = @max_time
    end
    # ======================

    case @step_metric
    when "month"
      @format_date = ("%m.%Y")
    when "day"
      @format_date = ("%D")
    when "hour"
      @format_date = ("%D %H")
      @show_time = true
    else
      @format_date = ("%D %H:%M")
      @show_time = true
    end


    @all_metrics = choose_system_metric(@step_metric).where(
      "get_time >= ? AND get_time <= ?",
      @begin_date.strftime(format_c3_date("second")),
      @end_date.strftime(format_c3_date("second"))
    ).order(:get_time)

    @metrics = @all_metrics.last(100).map{|metric| [
      DateTime.strptime(metric.get_time.strftime(@format_date), @format_date),
      metric.cpu_average, metric.memory_used, metric.swap_used, metric.descriptors_used]}

    render :get_ajax_table_main_metric, :layout => false
  end
  # ============================================================================

  def index
    @hot_catch_apps = HotCatchApp.paginate(:page => params[:page]).order('created_at DESC')
  end

  # ============================================================================
  def load_rails_graph
    if params[:rails_graph_form_step].blank?
      @step_metric = "hour"
      @show_time = true
    else
      @step_metric = params[:rails_graph_form_step]
    end

    # raise @step_metric

    case @step_metric
    when "month"
      @format_date = ("%m.%Y")
    when "day"
      @format_date = ("%D")
    when "hour"
      @format_date = ("%D %H")
      @show_time = true
    else
      @format_date = ("%D %H:%M")
      @show_time = true
    end

    @moment_format = format_moment(@step_metric)
    @parse_c3_date_format = format_c3_date(@step_metric)
    @show_datetime_format = format_show_datetime(@step_metric)

    @requests = UserRequest.non_success_count_date(@hot_catch_app, @format_date)
    a1, a2 = ["x"], ["Rails"]
    @requests.each{ |a| a1 << DateTime.strptime(a[0], @format_date)
      .strftime(@parse_c3_date_format); a2 << a[1] }
    @requests = [a1, a2]

    render :load_rails_graph, :layout => false
  end

  def show_rails_graph
    gon.load_rails_graph_path = load_rails_graph_hot_catch_app_url(@hot_catch_app)
  end

  def show
    @logs = @hot_catch_app.main_hot_catch_logs
    unless !params[:type].present? || (params[:type] == "all-filter")
      case params[:type]
      when "rails-server-filter"
        @logs = @logs.where(from_log: "Rails", status: "SERVER_ERROR")
      when "rails-client-filter"
        @logs = @logs.where(from_log: "Rails", status: "CLIENT_ERROR")
      end
    end
    @logs = @logs.paginate(:page => params[:page]).order('created_at DESC')
    respond_to do |format|
      @filter = params[:type]
      format.js {render layout: false}
      format.html
    end
  end
  # ============================================================================

  def new
    @hot_catch_app = HotCatchApp.new
  end

  def edit
  end

  def create
    @hot_catch_app = HotCatchApp.new(hot_catch_app_params)

    respond_to do |format|
      if @hot_catch_app.save
        format.html { redirect_to @hot_catch_app, notice: 'Hot catch app was successfully created.' }
        format.json { render :show, status: :created, location: @hot_catch_app }
      else
        format.html { render :new }
        format.json { render json: @hot_catch_app.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @hot_catch_app.update(hot_catch_app_params)
        format.html { redirect_to @hot_catch_app, notice: 'Hot catch app was successfully updated.' }
        format.json { render :show, status: :ok, location: @hot_catch_app }
      else
        format.html { render :edit }
        format.json { render json: @hot_catch_app.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @hot_catch_app.destroy
    respond_to do |format|
      format.html { redirect_to hot_catch_apps_url, notice: 'Hot catch app was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def choose_system_metric(step)
    case step
    when "year"
      @hot_catch_app.system_metric_step_days
    when "month"
      @hot_catch_app.system_metric_step_days
    when "day"
      @hot_catch_app.system_metric_step_days
    when "hour"
      @hot_catch_app.system_metric_step_hours
    else
      @hot_catch_app.system_metrics
    end
  end

  def choose_system_metric_for_integrate_graph(step)
    case step
    when "year"
      SystemMetricStep::Day
    when "month"
      SystemMetricStep::Day
    when "day"
      SystemMetricStep::Day
    when "hour"
      SystemMetricStep::Hour
    else
      SystemMetric
    end
  end

  def choose_network_metric(step, network_name)
    case step
    when "year"
      @hot_catch_app.network_step_days.where(name: network_name)
    when "month"
      @hot_catch_app.network_step_days.where(name: network_name)
    when "day"
      @hot_catch_app.network_step_days.where(name: network_name)
    when "hour"
      @hot_catch_app.network_step_hours.where(name: network_name)
    else
      @hot_catch_app.networks.where(name: network_name)
    end
  end

  def choose_networks_for_integrate_graph(step)
    case step
    when "year"
      NetworkStep::DayNetwork
    when "month"
      NetworkStep::DayNetwork
    when "day"
      NetworkStep::DayNetwork
    when "hour"
      NetworkStep::HourNetwork
    else
      Network
    end
  end

  def set_hot_catch_app
    @hot_catch_app = HotCatchApp.find(params[:id])
  end

  def hot_catch_app_params
    params.require(:hot_catch_app).permit(:name)
  end
end
