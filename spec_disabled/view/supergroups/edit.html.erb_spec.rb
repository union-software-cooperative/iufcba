require 'spec_helper'

describe "supergroups/edit" do
  before(:each) do
    @supergroup = assign(:supergroup, stub_model(Supergroup,
      :name => "MyString",
      :type => "",
      :www => "MyString"
    ))
  end

  it "renders the edit supergroup form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", supergroup_path(@supergroup), "post" do
      assert_select "input#supergroup_name[name=?]", "supergroup[name]"
      assert_select "input#supergroup_type[name=?]", "supergroup[type]"
      assert_select "input#supergroup_www[name=?]", "supergroup[www]"
    end
  end
end
