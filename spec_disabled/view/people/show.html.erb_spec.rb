require 'spec_helper'

describe "people/show" do
  before(:each) do
    @person = assign(:person, stub_model(Person,
      :firstname => "Firstname",
      :lastname => "Lastname",
      :title => "Title",
      :address => "MyText",
      :mobile => "Mobile",
      :fax => "Fax",
      :email => "Email"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Firstname/)
    rendered.should match(/Lastname/)
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    rendered.should match(/Mobile/)
    rendered.should match(/Fax/)
    rendered.should match(/Email/)
  end
end
