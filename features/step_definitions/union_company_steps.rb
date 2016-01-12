Given(/^there's a "(.*?)" titled "(.*?)"$/) do |entity, title|
	FactoryGirl.create(entity.to_sym, name: title)
end

When(/^I'm on the "(.*?)" list$/) do |entity|
	visit polymorphic_path(entity)
end

Then(/^I can view the "(.*?)" titled "(.*?)"$/) do |entity_name, title|
	klass = entity_name.titlecase.constantize
	entity = klass.find_by_name(title)

	page.should have_link(title, href: polymorphic_path(entity))
	click_link(title)
	
	page.should have_link(title)
	page.should have_selector(:link_or_button, 'Create Post')
end

Then(/^I can edit the "(.*?)" titled "(.*?)"$/) do |entity_name, title|
	klass = entity_name.titlecase.constantize
	entity = klass.find_by_name(title)

	page.should have_link('', href: edit_polymorphic_path(entity))
	visit edit_polymorphic_path(entity)

	fill_in "#{entity_name}[name]", with: "New Company Name"
	click_button "Update #{entity_name.titlecase}"

	page.should have_content("New Company Name")
end

Then(/^I can add a "(.*?)" titled "(.*?)"$/) do |entity_name, title|
	klass = entity_name.titlecase.constantize
	page.should have_link("New #{entity_name.titlecase}", href: new_polymorphic_path(klass))
	visit new_polymorphic_path(klass)

	new_name = #{entity_name.titlecase}
	fill_in "#{entity_name}[name]", with: new_name
	click_button "Create #{entity_name.titlecase}"

	page.should have_content(new_name)
end

Then(/^I can delete the "(.*?)" titled "(.*?)"$/) do |entity_name, title|
	klass = entity_name.titlecase.constantize
	entity = klass.find_by_name(title)
	entity.should_not eq(nil)

	click_link title
	click_link '', edit_polymorphic_path(entity)
	click_link "Permanently Delete This #{klass.to_s}" # TODO Assumes only one company in list

	#click_link "Destroy" # TODO Assumes only one company in list
	#all('td', text: title)[0].find(:xpath, '..').click_link("Destroy")

	entity = klass.find_by_name(title)
	entity.should eq(nil)

	page.should have_content("#{entity_name.titlecase} was successfully destroyed.")
end

