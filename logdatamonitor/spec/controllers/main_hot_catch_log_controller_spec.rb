require "rails_helper"

RSpec.describe MainHotCatchLogsController, :type => :controller do

  # before(:all) {3.times{ FactoryGirl.create(:main_hot_catch_log) }}
  #
  # describe "POST #create" do
  #   describe "found log" do
  #     it "hasn't count_log in params" do
  #       name_app = "my_app1"
  #       id_log_origin_app = 1
  #
  #       count_log_before = MainHotCatchLog.where(name_app: name_app,
  #         id_log_origin_app: id_log_origin_app).first.count_log
  #
  #       params = {:main_hot_catch_log => {"log_data":"some message","name_app":name_app,
  #         "id_log_origin_app":id_log_origin_app, "from_log":"Rails","status":"SERVER_ERROR"} }
  #
  #       post :create, params: params, format: :json
  #
  #       expect(response).to be_unprocessable
  #
  #       expect(MainHotCatchLog.where(name_app: name_app,
  #         id_log_origin_app: id_log_origin_app).first.count_log).to eq(count_log_before)
  #     end
  #
  #     it "has count_log in params" do
  #       name_app = "my_app1"
  #       id_log_origin_app = 1
  #       count_log = 100
  #
  #       params = {:main_hot_catch_log => {"log_data":"some message","count_log":count_log,
  #         "id_log_origin_app":id_log_origin_app,"name_app":"#{name_app}",
  #         "from_log":"Rails","status":"SERVER_ERROR"} }
  #
  #       post :create, params: params, format: :json
  #
  #       expect(MainHotCatchLog.where(name_app: name_app,
  #         id_log_origin_app: id_log_origin_app).first.count_log).to eq(count_log)
  #
  #       expect(response).to be_success
  #     end
  #   end
  #
  #
  #   describe "NOT found log" do
  #     it "All parameters" do
  #       name_app = "my_app100"
  #       id_log_origin_app = 1
  #
  #       count_logs_before = MainHotCatchLog.count
  #
  #       params = {:main_hot_catch_log => {"log_data":"some message","count_log":20,
  #         "id_log_origin_app":id_log_origin_app,"name_app":"#{name_app}",
  #         "from_log":"Rails","status":"SERVER_ERROR"} }
  #
  #       post :create, params: params, format: :json
  #       expect(response).to be_success
  #       expect(MainHotCatchLog.count).to eq(count_logs_before + 1)
  #     end
  #
  #     it "Hasn't needs parameter (for example name_app)" do
  #       id_log_origin_app = 1
  #
  #       count_logs_before = MainHotCatchLog.count
  #
  #       params = {:main_hot_catch_log => {"log_data":"some message","count_log":20,
  #         "id_log_origin_app":id_log_origin_app,
  #         "from_log":"Rails","status":"SERVER_ERROR"} }
  #
  #       post :create, params: params, format: :json
  #       expect(response).to be_unprocessable
  #       expect(MainHotCatchLog.count).to eq(count_logs_before)
  #     end
  #
  #     it "Hasn't no needs parameter (for example count)" do
  #       name_app = "my_app101"
  #       id_log_origin_app = 1
  #
  #       count_logs_before = MainHotCatchLog.count
  #
  #       params = {:main_hot_catch_log => {"log_data":"some message",
  #         "id_log_origin_app":id_log_origin_app,"name_app":"#{name_app}",
  #         "from_log":"Rails","status":"SERVER_ERROR"} }
  #
  #       post :create, params: params, format: :json
  #       expect(response).to be_success
  #       expect(MainHotCatchLog.count).to eq(count_logs_before + 1)
  #     end
  #   end
  #
  # end
end
