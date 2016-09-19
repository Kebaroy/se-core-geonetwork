@qa_ready
Feature: Sokning med generella alternativ
  
	Scenario: Search with Direktatkomliga resurser 
    Given that filtrering is shown 
    When the user clicks the button Direktatkomliga resurser
	Then Testpost_direktatkomliga_resurser_Geodatasamverkan is listed
	
	Scenario: Search with Karttjänster 
    Given that filtrering is shown 
    When the user clicks the button Favoriter
	Then Testpost_direktatkomliga_resurser_Karttjänster is listed

    Scenario: Show favoriter
    Given that filtrering is shown 
    When the user clicks the button to show Favoriter
    Then Titel=Testpost_Favoriter is listed
      
    Scenario: Show Geoteknik
    Given that filtrering is shown 
    When the user clicks the button to show Geoteknik
    Then Titel=Testpost_Geoteknik is listed
   
	Scenario: Show alla resurser
    Given that filtrering is shown 
    When the user clicks the button to visa alla resurser
    Then all selected filters are cleared
	And all posts are listed
   
	