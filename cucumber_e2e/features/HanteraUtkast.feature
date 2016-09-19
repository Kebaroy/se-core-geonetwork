@qa_ready
Feature: Hantera utkast

  Scenario: Hantera utkast
    Given that the user is in publishing mode
    When the user clicks the button to "Skapa ny metadatapost" 
	Then a form for "Redigera metadata" is displayed 
    
  Scenario: Skapa utkast
    Given that a post is open for editing
	When the user clicks on the spara utkast button
    Then a message is displayed that the post is updated
	And the identifierare for the post has the suffix utkast_1
  
  Scenario: Ta bort utkast
   	Given that the user has created a utkast
 	When the user clicks the button to ta bort utkast
    Then a message is displayed that the utkast has been removed
    And the identifierare does not have the removed utkast as a suffix