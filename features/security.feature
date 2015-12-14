Feature: Admins will have more rights that regular users
	@javascript
	Scenario: Admin can invite people from any union
   	Given I am authenticated as admin
   	Given there's a "union" titled "NUW"
	 	Then I can invite a user to the union "NUW"
 	Scenario: User can only invite people within their union
 		Given I am a new, authenticated person 
		Given there's a "union" titled "NUW"
		Then I can not invite a user to the union "NUW"
 	Scenario: Hacker can not invite people from any union
 		Given I am a new, authenticated person 
		Given there's a "union" titled "IUF"
		Then I can not post an invite to union "IUF"
	Scenario: Hacker can escalate his union priviledges
 		Given I am a new, authenticated person 
		Given there's a "union" titled "IUF"
		Then I can not post my profile with union "IUF"
	Scenario: Hacker attempts to edit someone outside there union
		Given I am a new, authenticated person 
		Given there's an administrator
		Then I am forbidden from editing the administrator
	Scenario: User attempts to edit someone from there union
		Given I am a new, authenticated person 
		Given there's another user called "bill" in my union
		Then I am permitted to edit "bill"
	


	Scenario: User can create and edit agreements for their own union
	# Tested in rec_controller_spec
	Scenario: User cannot assign an agreement to a contact outside their union
	# Tested in rec_controller_spec &  person_controller_spec 
	Scenario: Admin can create an agreement for any union
	# Tested in rec_controller_spec & views/rec/edit spec
	Scenario: Admin can edit an agreement from any union
	# Tested in rec_controller_spec 
	Scenario: Admin can assign to an agreement a contact from any union
	# Tested in rec_controller_spec 
	Scenario: User cannot create a company
	# Tested in supergroups_controller_spec
	Scenario: User cannot create a union
	# Tested in supergroups_controller_spec
	Scenario: Admin can create a company
	# Tested in supergroups_controller_spec
	Scenario: Admin can create a union
	# Tested in supergroups_controller_spec
	Scenario: User cannot view or edit contact details for people outside their own union
	# 

	
	
	
	