class HandleRequestController < ApplicationController
  def start
    if params[:send].present?
      # sender_logs = HotCatch::MakeHttpsRequest.new
      body_log = {main_hot_catch_log: {
        "log_data":"some message",
        "name_app":"app",
        "from_log":"Rails",
        "status":"200"}
      }
      Rails.application.config.sender_logs.send_log(body_log)
    end
  end

end
