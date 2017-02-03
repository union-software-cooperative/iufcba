require 'spec_helper'

describe "divisions/index" do
  before(:each) do
    @divisions = assign(:divisions, [FactoryGirl.create(:division),FactoryGirl.create(:division)])

  end

  it "renders a list of divisions" do
    allow(view).to receive(:owner?).and_return(false)
    render
    
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select ".row>h2", :text => "MyString".to_s, :count => 2
  end
end

