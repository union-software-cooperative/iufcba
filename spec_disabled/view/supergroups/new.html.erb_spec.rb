require 'spec_helper'

describe "supergroups/new" do
  before(:each) do
    assign(:supergroup, stub_model(Supergroup,
      :name => "MyString",
      :type => "",
      :www => "MyString"
    ).as_new_record)
  end

  it "renders new supergroup form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", supergroups_path, "post" do
      assert_select "input#supergroup_name[name=?]", "supergroup[name]"
      assert_select "input#supergroup_type[name=?]", "supergroup[type]"
      assert_select "input#supergroup_www[name=?]", "supergroup[www]"
    end
  end
end
