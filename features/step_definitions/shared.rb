Given /^I am not authenticated$/ do
  visit('/people/sign_out') # ensure that at least
end

Given /^I am a new, authenticated person$/ do
  email = 'tester@iuf.org'
  password = 'secretpass'
  @current_person = FactoryGirl.create(:person, :email => email, :password => password, :password_confirmation => password)
  @current_person.save!
  
  visit '/people/sign_in'
  fill_in "person_email", :with => email
  fill_in "person_password", :with => password
  click_button "Log in"
end

Given /^I am authenticated as admin$/ do
  # Admin is created by seed
	@current_person = Person.find_by_first_name('Admin')
  visit '/people/sign_in'
  fill_in "person_email", :with => @current_person.email
  fill_in "person_password", :with => 'temptemp'
  click_button "Log in"
end