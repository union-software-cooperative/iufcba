Then(/^I can edit my profile$/) do
	click_link "my profile"
	fill_in "First name", with: "billy"
	fill_in "Last name", with: "bob"
	click_button "Save Profile"
	page.should have_content "Profile successfully updated"
end

Then(/^I can add a profile picture$/) do
	click_link "my profile"
	#@file = fixture_file_upload("profile.jpeg", "image/jpeg")
	attach_file "Profile picture", 'spec/fixtures/profile.jpeg'
	click_button "Save Profile"
end

Then(/^I can see my profile picture$/) do
	page.should have_selector("img.profile_logo")
end



