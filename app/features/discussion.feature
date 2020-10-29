Feature: Discussion
	Scenario:  Posting against an agreement
		Given I am a new, authenticated person 
		Given I'm looking at an agreement titled "Test Agreement" 
		Then I can post "blah blah blah"
		Then I can comment "ya ya ya" beneath "blah blah blah"

	Scenario: Posting against a company
		Given I am a new, authenticated person 
		Given I'm looking at a company titled "Mondelez" 
		Then I can post "blah blah blah"
		Then I can comment "ya ya ya" beneath "blah blah blah"
		
	Scenario: Delete my own postings
		Given I am a new, authenticated person 
		Given I'm looking at an agreement with "my" posting "blah blah blah"
		Then I can delete the posting "blah blah blah"
		Then I should not see "blah blah blah"

	Scenario: Delete my own comments
		Given I am a new, authenticated person 
		Given I'm on an agreement with "my" posting "blah blah blah" and "my" comment "ya ya ya"
		Then I can delete the comment "ya ya ya" from "blah blah blah"
		Then I should still see "blah blah blah"
		Then I should not see "ya ya ya"

	Scenario: Can't delete other user's postings
		Given I am a new, authenticated person 
		Given I'm looking at an agreement with "somebody's" posting "blah blah blah"
		Then I can't delete the posting "blah blah blah"

	Scenario: Can't delete other user's comments
		Given I am a new, authenticated person 
		Given I'm on an agreement with "my" posting "blah blah blah" and "somebody's" comment "ya ya ya"
		Then I can't delete the comment "ya ya ya" from "blah blah blah"

	Scenario: A hacker attempts to delete a post
		Given I am a new, authenticated person 
		Given I'm on an agreement with "somebody's" posting "blah blah blah" and "somebody's" comment "ya ya ya"
		Then I can't force delete the posting "blah blah blah"

	Scenario: A hacker attempts to delete a comment
		Given I am a new, authenticated person 
		Given I'm on an agreement with "somebody's" posting "blah blah blah" and "somebody's" comment "ya ya ya"
		Then I can't force delete the comment "ya ya ya" from "blah blah blah"
		