require 'rails_helper'

describe "recs/new.html.erb" do
  before(:each) do
    @rec = assign(:rec, FactoryGirl.create(:authorized_agreement))
    @division = assign(:division, FactoryGirl.create(:division))
  end
  
  it "doesn't render warning when user can set a union" do
    allow(view).to receive(:owner?).and_return(true)
    render

    expect(rendered).to_not have_content('you can only create and edit agreements')
    assert_select("form[action='#{recs_path}'][method='post']") do
      assert_select("input#rec_attachment[name='rec[attachment]']")
      assert_select("select#rec_divisions[name='rec[divisions][]']")
      assert_select("select#rec_company_id[name='rec[company_id]']")
      assert_select("select#rec_union_id[name='rec[union_id]']")
      assert_select("select#rec_person_id[name='rec[person_id]']")
      assert_select("input#rec_name[name='rec[name]']")
    end
  end

  it "renders warning when user can't set a union" do
    allow(view).to receive(:owner?).and_return(false)
    render

    expect(rendered).to have_content('you can only create and edit agreements')
  end
end
