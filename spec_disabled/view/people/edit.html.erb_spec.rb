require 'spec_helper'

describe "people/edit" do
  before(:each) do
    @person = assign(:person, stub_model(Person,
      :firstname => "MyString",
      :lastname => "MyString",
      :title => "MyString",
      :address => "MyText",
      :mobile => "MyString",
      :fax => "MyString",
      :email => "MyString"
    ))
  end

  it "renders the edit person form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", person_path(@person), "post" do
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
