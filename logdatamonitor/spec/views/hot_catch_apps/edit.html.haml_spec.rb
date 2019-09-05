require 'rails_helper'

RSpec.describe "hot_catch_apps/edit", type: :view do
  before(:each) do
    @hot_catch_app = assign(:hot_catch_app, HotCatchApp.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit hot_catch_app form" do
    render

    assert_select "form[action=?][method=?]", hot_catch_app_path(@hot_catch_app), "post" do

      assert_select "input#hot_catch_app_name[name=?]", "hot_catch_app[name]"
    end
  end
end
