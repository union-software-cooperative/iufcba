require 'spec_helper'

describe "divisions/show" do
  before(:each) do
    @division = assign(:division, stub_model(Division,
      :name => "Name",
      :short_name => "Short Name",
      :logo => "Logo",
      :colour1 => "Colour1",
      :colour2 => "Colour2"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Short Name/)
    rendered.should match(/Logo/)
    rendered.should match(/Colour1/)
    rendered.should match(/Colour2/)
  end
end
