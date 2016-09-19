@qa_ready
Feature: Visa kartjanster
  
  Scenario: Visa kartjanster
    Given that the user is in search vy
    When the user clicks the button Visa kartjanster
    Then Testpost_karttjanster_resurser_Geodatasamverkan is listed
    
 