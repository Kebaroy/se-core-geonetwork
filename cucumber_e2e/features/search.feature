Feature: Search for metadata
  As a user of Protractor
  I should be able to use Cucumber
  to run my E2E tests

  Scenario: FreetextSearch
    Given I go to "Geodata.se - Lantmäteriet"
    Then  I type "Afrika" i searchfield
    
	