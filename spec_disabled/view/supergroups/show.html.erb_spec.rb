require 'spec_helper'

describe "supergroups/show" do
  before(:each) do
    @supergroup = assign(:supergroup, stub_model(Supergroup,
      :name => "Name",
      :type => "Type",
      :www => "Www"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Type/)
    rendered.should match(/Www/)
  end
end
