Then(/^I can add an agreement to the "(.*?)" division titled "(.*?)" between "(.*?)" and "(.*?)" and assigned to "(.*?)" with tag "(.*?)"$/) do |division, title, company, union, assignee, tag|
  page.should have_link("New Agreement", href: new_rec_path(division_id: division))
  visit new_rec_path(division_id: division)
  fill_in "rec[name]", with: title
  select2 division, div: "division-select2"
  select2 company, label: "Company"
  select2 union, label: "Union"
  select2 assignee, label: "Person"
  select2 tag, placeholder: "Please select one or more product types, or add your own (and press enter)"
  
  #select2 "union", "rec[union_id]"
  #Capybara.current_session.driver.browser.execute_script("window.scrollTo(0,document.body.scrollHeight)");
  Capybara.current_session.driver.browser.execute_script("window.scrollTo(0,window.scrollMaxY)");
  
  click_button "Save Agreement"
  sleep(1)
  #page.save_screenshot('asdf.jpg')
  page.should have_content(title)
  page.should have_content(tag)
  # has two divisions now attached
  page.should have_link("dairy")
  page.should have_link("dairy division")
end

Then(/^I can add an agreement with no data$/) do 
  page.should have_link("New Agreement", href: new_rec_path)
  visit new_rec_path

  click_button "Save Agreement"

  page.should have_content("Name can't be blank")
  page.should have_content("Union can't be blank")
  page.should have_content("Person can't be blank")
  page.should have_content("Company can't be blank")
end
