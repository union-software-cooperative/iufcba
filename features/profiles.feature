Feature: User profiles
	Scenario: User can have a profile picture
		Given I am a new, authenticated person 
		Then I can edit my profile
		Then I can add a profile picture
		When I click the "people" link
		Then I can see my profile picture
