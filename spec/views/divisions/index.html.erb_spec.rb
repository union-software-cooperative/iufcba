require 'spec_helper'

describe "divisions/index" do
  before(:each) do
    assign(:divisions, [
      stub_model(Division,
        :name => "Name",
        :short_name => "Short Name",
        :logo => "Logo",
        :colour1 => "Colour1",
        :colour2 => "Colour2"
      ),
      stub_model(Division,
        :name => "Name",
        :short_name => "Short Name",
        :logo => "Logo",
        :colour1 => "Colour1",
        :colour2 => "Colour2"
      )
    ])
  end

  it "renders a list of divisions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Short Name".to_s, :count => 2
    assert_select "tr>td", :text => "Logo".to_s, :count => 2
    assert_select "tr>td", :text => "Colour1".to_s, :count => 2
    assert_select "tr>td", :text => "Colour2".to_s, :count => 2
  end
end
