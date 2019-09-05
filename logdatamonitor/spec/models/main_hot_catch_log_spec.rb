require "rails_helper"

RSpec.describe MainHotCatchLog, :type => :model do
  # describe "Method MainHotCatchLog.find_and_count_log_if_exist(id_log, name_app, count_log)" do
  #
  #   before(:all) {3.times{ FactoryGirl.create(:main_hot_catch_log) }}
  #   around(:example) do |example|
  #     n = MainHotCatchLog.count
  #     example.run
  #     expect(MainHotCatchLog.count).to eq(n)
  #   end
  #
  #   it "args nil" do
  #     expect(MainHotCatchLog.find_and_count_log_if_exist(nil, nil, nil)).to eq(false)
  #   end
  #   it "args empty strings" do
  #     expect(MainHotCatchLog.find_and_count_log_if_exist("", "", "")).to eq(false)
  #   end
  #   it "no count_log (record exist, but return false because need to return errors to users in request)" do
  #     expect(MainHotCatchLog.find_and_count_log_if_exist(1, "my_app1", nil)).to eq(false)
  #   end
  #   it "no app_id" do
  #     expect(MainHotCatchLog.find_and_count_log_if_exist(nil, "my_app1", 3)).to eq(false)
  #   end
  #   it "app_id not integer" do
  #     expect(MainHotCatchLog.find_and_count_log_if_exist(".", "my_app1", 3)).to eq(false)
  #   end
  #   it "app_id empty string" do
  #     expect(MainHotCatchLog.find_and_count_log_if_exist(" ", "my_app1", 3)).to eq(false)
  #   end
  #   it "no app_name" do
  #     expect(MainHotCatchLog.find_and_count_log_if_exist(1, " ", nil)).to eq(false)
  #   end
  #   it "id not exist in db with id, but exist app_name and no count_log" do
  #     expect(MainHotCatchLog.find_and_count_log_if_exist(100, "my_app1", nil)).to eq(false)
  #   end
  #   it "record exist with another count_log" do
  #     expect(MainHotCatchLog.find_and_count_log_if_exist(1, "my_app1", 100)).to eq(true)
  #     expect(MainHotCatchLog.where(id_log_origin_app: 1, name_app: "my_app1").first.count_log).to eq(100)
  #   end
  #   it "record exist with the same count_log" do
  #     expect(MainHotCatchLog.find_and_count_log_if_exist(1, "my_app1", 1)).to eq(true)
  #     expect(MainHotCatchLog.where(id_log_origin_app: 1, name_app: "my_app1").first.count_log).to eq(1)
  #   end
  #   it "id not exist in db, but exist app_name" do
  #     expect(MainHotCatchLog.find_and_count_log_if_exist(100, "my_app1", 1)).to eq(false)
  #   end
  #   it "id exist in db with id, but not exist app_name" do
  #     expect(MainHotCatchLog.find_and_count_log_if_exist(100, "my_app100", 1)).to eq(false)
  #   end
  #
  # end
end
