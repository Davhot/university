module HotCatchAppsHelper
  def case_status_class(status)
    status == 'SUCCESS' ? "success-color" : "error-color"
  end

end
