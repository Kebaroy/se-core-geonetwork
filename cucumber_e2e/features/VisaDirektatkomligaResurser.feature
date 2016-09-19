@qa_ready
Feature: Visa direktatkomliga resurser
  
  Scenario: Visa direktatkomliga resurser 
    Given that the user is in Enkel eller avancerad vy
    When the user clicks the button Visa direktatkomliga resurser 
    Then Testpost_direktatkomliga_resurser_Geodatasamverkan is listed

	 