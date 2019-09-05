require 'rails_helper'

RSpec.describe "hot_catch_apps/index", type: :view do
  before(:each) do
    assign(:hot_catch_apps, [
      HotCatchApp.create!(
        :name => "Name"
      ),
      HotCatchApp.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of hot_catch_apps" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
