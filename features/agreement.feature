Feature: An agreement shall have one company, one union and one contact person
	@javascript
	Scenario: Creating an agreement
	Given I am authenticated as admin
  Given there's a "company" titled "Mondelez"
	Given there's a "union" titled "NUW"
	Given there's a "dairy" division
	When I'm on the "dairy" division "agreements" list
	Then I can add an agreement to the "dairy" division titled "Mondelez vs NUW" between "Mondelez" and "NUW" and assigned to "Tester" with tag "cheese"


	Scenario: Failing to creating an agreement
	Given I am authenticated as admin
  When I'm on the "agreements" list
	Then I can add an agreement with no data
