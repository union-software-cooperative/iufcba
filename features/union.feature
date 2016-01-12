Feature: Maintain a list of unions
	Scenario: Add a union
		Given I am authenticated as admin
  	When I'm on the "unions" list
		Then I can add a "union" titled "NUW"
		
	Scenario: Edit a union
		Given I am authenticated as admin
		Given there's a "union" titled "NUW"
		When I'm on the "unions" list
		Then I can view the "union" titled "NUW"
		Then I can edit the "union" titled "NUW"
	
	Scenario: Delete a union
		Given I am authenticated as admin
		Given there's a "union" titled "NUW"
		When I'm on the "unions" list
		Then I can delete the "union" titled "NUW"

	Scenario: Upload banner to union
		