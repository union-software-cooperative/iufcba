require 'rails_helper'

describe "layouts/_navbar" do
  it "renders a breadcrumb" do
    allow(view).to receive(:person_signed_in?).and_return(false)
    @breadcrumbs = assign(:breadcrumbs, [["Home", "/", true]])
    # allow(view).to receive(:owner?).and_return(false)
    render
    
    # Should have one breadcrumb...
    assert_select "ol.breadcrumb > li", count: 1
    # ...but it shouldn't be a link.
    assert_select "ol.breadcrumb > li > a", count: 0
  end
  
  it "renders several breadcrumbs" do
    allow(view).to receive(:person_signed_in?).and_return(false)
    @breadcrumbs = assign(:breadcrumbs, [["Root", "/", false], ["Tier 2", "/2", false], ["Tier 3", "/2/3", true]])
    render
    
    # Should have three breadcrumbs...
    assert_select "ol.breadcrumb > li", count: 3
    # ...and two of them should be links.
    assert_select "ol.breadcrumb > li > a", count: 2
  end
end
