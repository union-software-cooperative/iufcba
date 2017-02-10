require 'rails_helper'

describe "divisions/index" do
  before(:each) do
    @divisions = assign(:divisions, [FactoryGirl.create(:division),FactoryGirl.create(:division)])
  end

  it "renders a list of divisions" do
    allow(view).to receive(:owner?).and_return(false)
    render
    
    assert_select "tbody tr", :text => "MyString".to_s, :count => 2
  end

  describe "low privilege access" do
    it "doesn't show the new button" do
      allow(view).to receive(:owner?).and_return(false)
      render
      assert_select ".btn", { :text => "New Division", count: 0 }
    end

    it "doesn't show the edit button" do
      allow(view).to receive(:owner?).and_return(false)
      render
      assert_select ".btn.glyphicon-pencil", count: 0
    end
  end

  describe "high privilege access" do
    it "shows the new button" do
      allow(view).to receive(:owner?).and_return(true)
      render
      assert_select ".btn", { :text => "New Division" }
    end

    it "shows the edit button" do
      allow(view).to receive(:owner?).and_return(true)
      render
      assert_select ".glyphicon-pencil"
    end
  end
end
