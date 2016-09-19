@qa_ready
Feature: Logga in och ut, skapa konto, nytt losenord
  
  Scenario: Visa inloggningsformular   
    Given that the user is in enkel eller avancerad vy 
    When the user clicks the button For publicerare
    Then a log in form is opened

  Scenario: Logga in   
    Given that the inloggningsformular is open 
    When the user enters login parameters 
    And clicks the button to log in
    Then the metadata editor is opened

  Scenario: Logga ut   
    Given that the user is in publicerare vy 
    When the user clicks the button Logga ut
    Then the enkel vy is opened

   Scenario: Bestall nytt losenord  
    Given that the user is in publicerare vy 
    When the user clicks the button bestall nytt losenord
    Then what?

   Scenario: Skapa konto  
    Given that the user is in publicerare vy 
    When the user clicks the button to skapa konto
    Then what?
    