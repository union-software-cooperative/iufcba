require 'spec_helper'

describe "supergroups/index" do
  before(:each) do
    assign(:supergroups, [
      stub_model(Supergroup,
        :name => "Name",
        :type => "Type",
        :www => "Www"
      ),
      stub_model(Supergroup,
        :name => "Name",
        :type => "Type",
        :www => "Www"
      )
    ])
  end

  it "renders a list of supergroups" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "Www".to_s, :count => 2
  end
end
