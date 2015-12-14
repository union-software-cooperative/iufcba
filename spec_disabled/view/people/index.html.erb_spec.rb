require 'spec_helper'

describe "people/index" do
  before(:each) do
    assign(:people, [
      stub_model(Person,
        :firstname => "Firstname",
        :lastname => "Lastname",
        :title => "Title",
        :address => "MyText",
        :mobile => "Mobile",
        :fax => "Fax",
        :email => "Email"
      ),
      stub_model(Person,
        :firstname => "Firstname",
        :lastname => "Lastname",
        :title => "Title",
        :address => "MyText",
        :mobile => "Mobile",
        :fax => "Fax",
        :email => "Email"
      )
    ])
  end

  it "renders a list of people" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Firstname".to_s, :count => 2
    assert_select "tr>td", :text => "Lastname".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Mobile".to_s, :count => 2
    assert_select "tr>td", :text => "Fax".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
  end
end
