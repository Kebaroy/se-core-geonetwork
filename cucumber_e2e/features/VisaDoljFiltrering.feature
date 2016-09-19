@qa_ready
Feature: Visa eller dolj filtrering
  
  Scenario: Visa filtrering 
    Given that filtreringsfalt are invisible
    When the user clicks the button to dolj filtrering
    Then all filtreringsfalt become visible 
    
  
  Scenario: Dolj filtrering 
    Given that filtreringsfalt are visible
    When the user clicks the button to visa filtrering
    Then all filtreringsfalt become invisible 
       