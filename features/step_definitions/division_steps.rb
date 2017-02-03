Given(/^there's a "(.*?)" division$/) do |title|
	FactoryGirl.create(:division, name: title, short_name: title)
end
