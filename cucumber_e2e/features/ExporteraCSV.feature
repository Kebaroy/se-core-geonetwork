@qa_ready
Feature: Exportera som csv

  Scenario: Exportera som csv 
    Given that the user is in publishing mode
	When the user selects the first 2 posts in the result list
	And clicks on the link Exportera markerade som CSV
	Then what happens? 
   