Feature: Open the national Geodataportal
  A user of the portal should meet a popup window on first visti on site
  I should be able to use Cucumber
  to run my E2E tests

  Scenario: start using geodata
    Given I go on "Geodata.se - Lantmäteriet"
    Then the title should equal "Geodata.se - Lantmäteriet"
    
	