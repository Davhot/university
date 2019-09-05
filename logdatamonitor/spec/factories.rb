FactoryGirl.define do
  factory :network_step do
    bytes_in 1.5
    bytes_out 1.5
    packets_in 1.5
    packets_out 1.5
    get_time "2017-12-14 22:24:26"
    hot_catch_app nil
  end
  factory :system_metric_hour do
    type ""
    count 1
    cpu_average_sum 1.5
    cpu_average 1.5
    memory_used 1.5
    memory_used_sum 1.5
    swap_used 1.5
    swap_used_sum 1.5
    descriptors_used 1
    descriptors_used_sum 1
    get_time "2017-12-11 22:08:38"
    count 1
  end
  factory :main_metric do
    memory_size 1
    swap_size 1
    descriptors_max 1
    architecture "MyString"
    os "MyString"
    os_version "MyString"
    host_name "MyString"
  end
  factory :network do
    bytes_in 1.5
    bytes_out 1.5
    packets_in 1.5
    packets_out 1.5
    system_metric nil
  end
  factory :disk do
    name "MyString"
    filesystem "MyString"
    size 1
    mounted_on "MyString"
    system_metric nil
  end
  factory :system_metric do
    cpu_average 1.5
    memory_size 1
    memory_used 1
    swap_size 1
    swap_used 1
    discriptors_max 1
    descriptors_used 1
  end
  factory :user_request do
    ip "MyString"
    request_time "2017-10-22 17:53:39"
  end
  factory :role_user do

  end
  factory :role do
    name "MyString"
    info "MyString"
    full_info "MyString"
  end
  factory :user do
    email "MyString"
    crypted_password "MyString"
  end
  factory :hot_catch_app do
    name "MyString"
  end
  factory :main_hot_catch_log do
    log_data            "some message"
    count_log           1
    sequence(:id_log_origin_app)  { |n| n }
    sequence(:name_app)  { |n| "my_app#{n}" }
    from_log            "Rails"
    status              "SERVER_ERROR"
  end
end
