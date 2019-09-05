class MainHotCatchLogsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  skip_before_action :require_login
  skip_before_action :check_app_auth

  # POST /main_hot_catch_logs.json
  def create
    @main_hot_catch_log = MainHotCatchLog.new(main_hot_catch_log_params)
    if params[:main_hot_catch_log][:from_log] == "System"
      @main_hot_catch_log.set_app_and_process_system_logs(params[:main_hot_catch_log][:log_data])
    else
      respond_to do |format|
        if @main_hot_catch_log.set_data_and_save
          format.json { head :ok }
        else
          format.json { render json: @main_hot_catch_log.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def main_hot_catch_log_params
      params.require(:main_hot_catch_log).permit(:log_data, :from_log, :name_app, :status)
    end

end
