require 'spec_helper'

describe "people/new" do
  before(:each) do
    assign(:person, stub_model(Person,
      :firstname => "MyString",
      :lastname => "MyString",
      :title => "MyString",
      :address => "MyText",
      :mobile => "MyString",
      :fax => "MyString",
      :email => "MyString"
    ).as_new_record)
  end

  it "renders new person form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", people_path, "post" do
      assert_select "input#person_firstname[name=?]", "person[firstname]"
      assert_select "input#person_lastname[name=?]", "person[lastname]"
      assert_select "input#person_title[name=?]", "person[title]"
      assert_select "textarea#person_address[name=?]", "person[address]"
      assert_select "input#person_mobile[name=?]", "person[mobile]"
      assert_select "input#person_fax[name=?]", "person[fax]"
      assert_select "input#person_email[name=?]", "person[email]"
    end
  end
end
