Given /^I am not authenticated$/ do
  visit('/en/people/sign_out') # ensure that at least
end

Given /^I am a new, authenticated person$/ do
  email = 'tester@iuf.org'
  password = 'secretpass'
  @current_person = FactoryGirl.create(:authorized_person, :email => email, :password => password, :password_confirmation => password)
  @current_person.save!
  
  visit '/en/people/sign_in'
  fill_in "person_email", :with => email
  fill_in "person_password", :with => password
  click_button "Sign in"
end

Given /^I am authenticated as admin$/ do
  # Admin is created by seed
  @current_person = admin(password: 'temptemp', password_confirmation: 'temptemp')

  visit '/en/people/sign_in'
  fill_in "person_email", :with => @current_person.email
  fill_in "person_password", :with => 'temptemp'
  click_button "Sign in"
end

Given(/^I am a new, authenticated person belonging to "(.*?)"$/) do |union_name|
  email = 'tester@iuf.org'
  password = 'secretpass'
  union = Union.find_by_name(union_name)
  @current_person = FactoryGirl.create(:person, :union => union, :email => email, :password => password, :password_confirmation => password)
  @current_person.save!
  
  visit '/en/people/sign_in'
  fill_in "person_email", :with => email
  fill_in "person_password", :with => password
  click_button "Sign in"
end






