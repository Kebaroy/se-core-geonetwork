@qa_ready
Feature: Redigera metadata post

  Scenario: Redigera metadata 
    Given that the user is in publishing mode
	When the user clicks on the redigera alternativ on the list Publicerarverktyg
	Then a form for redigera metadata is displayed 
 
  Scenario: Redigera and spara metadata post as draft
   	Given that the user is in redigera metadata mode
 	When the user edits a field
    And the user sparar the post as utkast
    Then a message is displayed that the post is updated
   
  Scenario: Revert to edit mode
   	Given that a positive feedback from the saving operation has been given to the user 
	When the user clicks OK 
	Then the user can continue editing the post