require 'rails_helper'

RSpec.describe "HotCatchApps", type: :request do
  describe "GET /hot_catch_apps" do
    it "works! (now write some real specs)" do
      get hot_catch_apps_path
      expect(response).to have_http_status(200)
    end
  end
end
