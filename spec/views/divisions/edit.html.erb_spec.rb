require 'rails_helper'

describe "divisions/edit" do
  before(:each) do
    @division = assign(:division, stub_model(Division,
      :name => "MyString",
      :short_name => "MyString",
      :logo => "MyString",
      :colour1 => "MyString",
      :colour2 => "MyString"
    ))
  end

  it "renders the edit division form" do
    render

    assert_select "form[action=?][method=?]", division_path(@division), "post" do
      assert_select "input#division_name[name=?]", "division[name]"
      assert_select "input#division_short_name[name=?]", "division[short_name]"
      assert_select "input#division_logo[name=?]", "division[logo]"
      assert_select "input#division_colour1[name=?]", "division[colour1]"
      assert_select "input#division_colour2[name=?]", "division[colour2]"
    end
  end
  
  it "renders the delete button" do
    # <%= link_to t(".permanently_delete"),division_path(@division), method: :delete, class: "btn btn-danger ", style: "margin: 15px; color: white", data: {confirm: t(".permanently_delete_confirm")} %>
    render
    
    assert_select(".btn.btn-danger[data-method=delete][data-confirm='Are you really really sure?']")
  end
end
