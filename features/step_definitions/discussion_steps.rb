
Given(/^I'm looking at an agreement titled "(.*?)"$/) do |title|
	agreement = FactoryGirl.create(:authorized_agreement, name: title )
	visit rec_path(agreement)
end

Given(/^I'm looking at a company titled "(.*?)"$/) do |title|
	company = FactoryGirl.create(:company, name: title )
	visit company_path(company)
end

Then(/^I can post "(.*?)"$/) do |post_body|
	starting_url = current_url
	fill_in "post_body", with: post_body
  click_button "Create post"
  page.should have_content("Post was successfully created.")
  current_url.should eq(starting_url)
  page.should have_content(post_body)
end

Then(/^I can comment "(.*?)" beneath "(.*?)"$/) do |comment_body, post_body|
	starting_url = current_url
	page.should have_content(post_body)
	p = find("p.post_body", text: post_body).find(:xpath, '..')
	within p do
		fill_in "comment_body", with: comment_body
		click_button "Post"
		current_url.should eq(starting_url)
	end

	page.should have_content("Comment was successfully created.")
  current_url.should eq(starting_url)
  p = find("p.post_body", text: post_body).find(:xpath, '..')
	p.should have_content(comment_body)
end

Given(/^I'm looking at an agreement with "(.*?)" posting "(.*?)"$/) do |who, post_body|
	agreement = FactoryGirl.create(:authorized_agreement, name: title )
	
	post = FactoryGirl.create(:post, person: get_person(who), parent: agreement, body: post_body)
	visit rec_path(agreement)
end


Given(/^I'm on an agreement with "(.*?)" posting "(.*?)" and "(.*?)" comment "(.*?)"$/) do |who, post_body, comment_who, comment_body|
	agreement = FactoryGirl.create(:authorized_agreement, name: title )
	post = FactoryGirl.create(:post, person: get_person(who), parent: agreement, body: post_body)
	comment = FactoryGirl.create(:comment, person: get_person(comment_who), post: post, body: comment_body)
	visit rec_path(agreement)
end

Then(/^I can delete the posting "(.*?)"$/) do |post_body|
	starting_url = current_url
	within find_post(post_body) do
		link = find(".delete")
		page.driver.submit :delete, link[:href], {}
	end
	current_url.should eq(starting_url)
end

Then(/^I should not see "(.*?)"$/) do |content|
	page.should_not have_content(content)
end

Then(/^I should still see "(.*?)"$/) do |content|
	page.should have_content(content)
end

Then(/^I can delete the comment "(.*?)" from "(.*?)"$/) do |comment_body, post_body|
	starting_url = current_url
	within find_post(post_body) do
		c = find("p.comment_body", text: comment_body).find(:xpath, '..')
		within c do 
			link = find(".delete")
			page.driver.submit :delete, link[:href], {}
		end
	end
	current_url.should eq(starting_url)
end

Then(/^I can't delete the comment "(.*?)" from "(.*?)"$/) do |comment_body, post_body|
	within find_post(post_body) do
		c = find("p.comment_body", text: comment_body).find(:xpath, '..')
		c.should have_no_selector(:css, "a[data-method='delete']")
	end
end


Then(/^I can't delete the posting "(.*?)"$/) do |post_body|
	find_post(post_body).should have_no_selector(:css, "a[data-method='delete']")
end

Then(/^I can't force delete the posting "(.*?)"$/) do |post_body|
	post = Post.find_by_body post_body
	url = post_path post
	page.driver.submit :delete, url, {}
	page.should have_content("You are not authorized to do that")
	page.should have_content(post_body)
end

Then(/^I can't force delete the comment "(.*?)" from "(.*?)"$/) do |comment_body, post_body|
	post = Post.find_by_body post_body
	comment = post.comments.find_by_body comment_body
	url = comment_path comment
	page.driver.submit :delete, url, {}
	page.should have_content("You are not authorized to do that")
	page.should have_content(post_body)
end

def get_person(who)
	person = @current_person
	if who != "my"
		person = Person.find_by_first_name who
		if person == nil
			person = FactoryGirl.create(:authorized_person, email: "#{who}@iuf.org", first_name: who)
		end
	end
	person
end

def find_post(post_body)
	find("p.post_body", text: post_body).find(:xpath, '..')
end
