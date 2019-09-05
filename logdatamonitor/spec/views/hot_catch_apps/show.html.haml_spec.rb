require 'rails_helper'

RSpec.describe "hot_catch_apps/show", type: :view do
  before(:each) do
    @hot_catch_app = assign(:hot_catch_app, HotCatchApp.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
