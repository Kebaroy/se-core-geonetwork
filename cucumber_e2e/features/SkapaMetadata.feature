@qa_ready
Feature: Create metadata post
  
  Scenario: Create metadata post
    Given that the user is in publishing mode
	When the user clicks the button to skapa ny metadatapost 
	Then a form for redigera metadata is displayed 
 
  Scenario: Save metadata post as draft
    Given that the user is in redigera metadata mode
	When the user correctly fills in all obligatoriska falt
	And the user clicks the button Spara utkast  
	Then a message is displayed that the metadata post has been saved as a draft 
 
  Scenario: Dolj obligatoriska falt
    Given that the user is in redigera metadata mode
	When the user selects to show only obligatoriska falt
	Then all fields that are not obligatoriska becomes invisible 
 
  Scenario: Visa obligatoriska falt
    Given that the user is in redigera metadata mode
	When the user selects to show all falt
	Then all fields becomes visible
  
  Scenario: Close form
    Given that the user has saved the post as draft
    When the user clicks on the button to close the form
    Then the post is displayed in result table
  