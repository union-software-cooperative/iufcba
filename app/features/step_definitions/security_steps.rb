

Then (/^I can invite a user to the union "(.*?)"$/) do |union|
  # Admin is created by seed
  @invitee = FactoryGirl.build(:person, password: 'temptemp', password_confirmation: 'temptemp')
  visit new_person_invitation_path(locale: :en)
  fill_in "person_email", :with => @invitee.email
  page.should have_field("Union")

  # fixed footer causes capybara to scroll insufficiently far and click in the wrong spot
  Capybara.current_session.driver.browser.execute_script("window.scrollTo(0,window.scrollMaxY)");
  select2_clear label: "Union"
  field_labeled('Email').click #browse away
  select2 union, argh: "person_union_select2"
  click_button "Send an invitation"
end

Then (/^I can not invite a user to the union "(.*?)"$/) do |union|
  # Admin is created by seed
  @invitee = FactoryGirl.build(:person, password: 'temptemp', password_confirmation: 'temptemp')
  visit new_person_invitation_path(locale: :en)
  fill_in "person_email", :with => @invitee.email
  page.should_not have_field("Union")
  page.should have_content("you can only assign yourself and other people to your union")
end


Then(/^I can not post an invite to union "(.*?)"$/) do |union|
  @invitee = FactoryGirl.build(:person, password: 'temptemp', password_confirmation: 'temptemp')
  @union = Union.find_by_name(union)

  visit new_person_invitation_path(locale: :en)
  fill_in "person_email", :with => @invitee.email
  find(:xpath, "//input[@id='person_union_id']", visible: false).set @union.id
  click_button "Send an invitation"
  page.should have_content("Authorizer cannot assign a person to a union other than their own.")
end

Then(/^I can not post my profile with union "(.*?)"$/) do |union|
  @union = Union.find_by_name(union)
  visit edit_person_path(@current_person, division_id: @current_person.union.divisions.first.id, locale: :en)

  find(:xpath, "//input[@id='person_union_id']", visible: false).set @union.id
  click_button "Save Profile"
  page.should have_content("Union cannot be changed.")
end

Given(/^there's an administrator$/) do
  @admin = admin
end

Then(/^I am forbidden from editing the administrator$/) do
  visit edit_person_path(admin, division_id: admin.union.divisions.first.id, locale: :en)
  page.status_code.should eq(403)
end

Given(/^there's another user called "(.*?)" in my union$/) do |name|
  FactoryGirl.create(:authorized_person, first_name: name, union: @current_person.union)
end

Given(/^there's another user called "(.*?)" in "(.*?)"$/) do |name, union_name|
  union = Union.find_by_name(union_name)
  FactoryGirl.create(:person, union: union, first_name: name)
end

Then(/^I am permitted to edit "(.*?)"$/) do |name|
  person = Person.find_by_first_name(name)
  visit edit_person_path(person, division_id: person.union.divisions.first.id, locale: :en)
  page.status_code.should eq(200)
  page.should have_content("Editing #{name}")

end

Then(/^I can edit the agreement titled "(.*?)"$/) do |name|
  rec = Rec.find_by_name(name)
  visit edit_rec_path(rec, locale: :en)
  page.should have_content("Editing Agreement")
end
