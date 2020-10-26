Feature: Maintain a list of companies
	Scenario: Add a company
		Given I am authenticated as admin
  	When I'm on the "companies" list
		Then I can add a "company" titled "Mondelez"
		
	Scenario: Edit a company
		Given I am authenticated as admin
  	Given there's a "company" titled "Mondelez"
		When I'm on the "companies" list
		Then I can view the "company" titled "Mondelez"
		Then I can edit the "company" titled "Mondelez"
	
	Scenario: Delete a company
		Given I am authenticated as admin
  	Given there's a "company" titled "Mondelez"
		When I'm on the "companies" list
		Then I can delete the "company" titled "Mondelez"
	