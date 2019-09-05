require 'spec_helper'
require 'helpers/generate_nginx_logs_helper.rb'
require 'hot_catch/receive_nginx_logs'

RSpec.configure do |c|
  c.include GenerateNginxLogsHelper
end

describe ReceiveNginxLogs do
  subject do
    r = ReceiveNginxLogs.new
    r.last_get_logs_time_filename = 'spec/nginx_files/time.txt'
    r.input_filename = 'spec/nginx_files/nginx.logs'
    r
  end

  after(:each){ clear_nginx_log; clear_nginx_time }

  describe "check get_last_logs" do
    it "no time, no logs" do
      expect(subject.get_last_logs.blank?).to eq(true)
    end

    it "no time, has logs" do
      count_logs = 3
      time = Time.current.strftime(subject.format_datetime_logs)
      count_logs.times{ append_nginx_log(time) }
      logs = subject.get_last_logs
      expect(logs.count("\n")).to eq(count_logs)
    end

    it "has time, has 4 logs (one log later last request, and one log after current time)" do
      count_logs = 4
      time = Time.current
      count_logs.times do |i|
        t = (time - (count_logs - i - 1).hours - 30.minutes).strftime(subject.format_datetime_logs)
        append_nginx_log(t)
      end
      generate_nginx_time((time - 2.hours).strftime(ReceiveNginxLogs::SinceDatetimeGetLogsFormat))

      logs = subject.get_last_logs
      expect(logs.count("\n")).to eq(2)
    end
  end
end
