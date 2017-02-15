require 'rails_helper'

describe "divisions/new" do
  before(:each) do
    assign(:division, stub_model(Division,
      :name => "MyString",
      :short_name => "MyString",
      :logo => "MyString",
      :colour1 => "MyString",
      :colour2 => "MyString"
    ).as_new_record)
  end

  it "renders new division form" do
    render

    assert_select("form[action='#{divisions_path}'][method='post']") do
      assert_select "input#division_name[name=?]", "division[name]"
      assert_select "input#division_short_name[name=?]", "division[short_name]"
      assert_select "input#division_logo[name=?]", "division[logo]"
      assert_select "input#division_colour1[name=?]", "division[colour1]"
      assert_select "input#division_colour2[name=?]", "division[colour2]"
    end
  end
end
