Given(/^there's a "(.*?)" division$/) do |title|
	division = FactoryGirl.create(:division, name: "#{title} division", short_name: title, logo: "#{title}.png")
end
