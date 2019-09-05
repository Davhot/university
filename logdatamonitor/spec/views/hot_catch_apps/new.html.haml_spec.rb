require 'rails_helper'

RSpec.describe "hot_catch_apps/new", type: :view do
  before(:each) do
    assign(:hot_catch_app, HotCatchApp.new(
      :name => "MyString"
    ))
  end

  it "renders new hot_catch_app form" do
    render

    assert_select "form[action=?][method=?]", hot_catch_apps_path, "post" do

      assert_select "input#hot_catch_app_name[name=?]", "hot_catch_app[name]"
    end
  end
end
