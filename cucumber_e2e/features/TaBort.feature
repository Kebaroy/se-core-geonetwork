@qa_ready
Feature: Ta bort metadata post
  
  Scenario: Ta bort 
    Given that the user is in publishing mode
	When the user clicks on the ta bort alternativ on the list Publicerarverktyg
	Then a question to confirm the removal is is displayed
  
  Scenario: Confirm ta bort 
    Given that the question to confirm the removal is displayed
	When the user select to confinue the removal
	Then the post is removed from the result list
  