Feature: Maintain a list of unions
	Scenario: Add a union
		Given I am a new, authenticated person
  	When I'm on the "unions" list
		Then I can add a "union" titled "NUW"
		
	Scenario: Edit a union
		Given I am a new, authenticated person
  	Given there's a "union" titled "NUW"
		When I'm on the "unions" list
		Then I can edit the "union" titled "NUW"
	
	Scenario: Delete a union
		Given I am a new, authenticated person
  	Given there's a "union" titled "NUW"
		When I'm on the "unions" list
		Then I can delete the "union" titled "NUW"

	Scenario: Upload banner to union
		