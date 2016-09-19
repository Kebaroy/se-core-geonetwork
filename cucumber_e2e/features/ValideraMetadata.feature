@qa_ready
Feature: Validate metadata post

  Scenario: Validate metadata post
    Given that the user is in publishing mode
	When the user clicks on the redigera alternativ on the list Publicerarverktyg
	Then a form for redigera metadata is displayed 
   
   Scenario: Validate Inspire post as valid
    Given that a post is open for editing
	And the post meets the initiativ
	When the user clicks the button to validate the post against Inspire
	Then the user receives a positive result for the initiativ 
 	
  Scenario: Validate Inspire post as invalid
    Given that a post is open for editing
    And the post belongs to the Inspire initiativ
    And the post does not meet the initiativ
	When the user clicks the button to validate the post against initiativ
	Then the user receives a negative resultat for the initiativ
	And the rules that were not met is displayed 
	
  Scenario: Kontrollera metadata  
    Given that the a post is open for editing 
    When the user clicks on the button to validate metadata
    Then a page with the validation result for metadata is opened
      
  Scenario: Kontrollera lankar och relationer 
    Given that the a post is open for editing 
    When the user clicks on the button to kontrollera lankar och relationer
    Then a page with the validation result for lankar och relationer is opened
	

	# hur testar vi att posten inte finns?
  	# Scenario: Failure when saving the open post as draft
    # Given that a post is open for editing
    # And the post does not exist in the database
	# When the user clicks the button to save the post
	# Then a message is displayed that the request has failed
	  
  Scenario: Revert to edit mode
    Given that a feedback from the saving operation has been given to the user 
	When the user clicks OK 
	Then the user can continue editing the post