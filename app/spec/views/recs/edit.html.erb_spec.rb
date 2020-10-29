require 'rails_helper'

describe "recs/edit" do
  before(:each) do
    @rec = assign(:rec, FactoryGirl.create(:authorized_agreement))
    @division = assign(:division, FactoryGirl.create(:division))
  end

  it "doesn't render warning when user can set a union" do
    allow(view).to receive(:owner?).and_return(true)
    render

    expect(rendered).to_not have_content('you can only create and edit agreements')
    assert_select("form[action='#{rec_path(@rec)}'][method='post']")
  end

  it "renders warning when user can't set a union" do
    allow(view).to receive(:owner?).and_return(false)
    render

    expect(rendered).to have_content('you can only create and edit agreements')
  end
end
