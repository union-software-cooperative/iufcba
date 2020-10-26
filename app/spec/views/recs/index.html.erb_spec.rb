require 'rails_helper'

describe "recs/index.html.erb" do
  before(:each) do
    admin = FactoryGirl.create(:admin, authorizer: Person.first)
    @division = FactoryGirl.create(:division)
    @recs = assign(:recs, [FactoryGirl.create(:agreement, authorizer: admin,  name: "my agreement"),FactoryGirl.create(:agreement, authorizer: admin, name: "my agreement")])
  end

  it "renders a list of agreements" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td:first", :count => 2
  end
end
