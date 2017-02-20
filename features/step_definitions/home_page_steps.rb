Given(/^there's an agreement titled "(.*?)" expiring "(.*?)"$/) do |title, expiry|
  @agreement = FactoryGirl.build(:agreement, name: title, end_date: Date.parse(expiry))
  @agreement.save(validate: false)
end

When(/^I am on the homepage$/) do
  visit root_path
end

Then(/^I should see the "(.*?)" agreement$/) do |title|
  @agreement = Rec.find_by_name(title)
  page.should have_content(@agreement.name)
  page.should have_content(I18n.l @agreement.end_date, :format => :long)
end

Then(/^I should see the link "(.*?)"$/) do |link_name|
  page.should have_link(link_name)
end

When(/^I click the "(.*?)" link$/) do |link_name|
  click_link(link_name)
end

Then(/^I see a list of "(.*?)"$/) do |items|
  page.should have_content("Listing #{items}")
end

Then(/^I should see "(.*?)" branding$/) do |division|
  #division = Division.find_by_short_name(division)
  division = Division::Translation.
    find_by_short_name(division).try(:globalized_model)
  page.should have_xpath("//img[@src=\"#{division.logo.url}\"]")
  expect(page).to have_title "#{I18n.t('layouts.application.title')} - #{division.name}"
end

Then(/^I should see application branding$/) do
  page.should have_xpath("//img[@src=\"/images/iuf_logo.png\"]")
  expect(page).to have_title I18n.t('layouts.application.title')
end
