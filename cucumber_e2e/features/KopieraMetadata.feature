@qa_ready
Feature: Kopiera metadata post

  Scenario: Oppna metadata post
    Given that the user is in publishing mode
	When the user clicks on the redigera alternativ on the list Publicerarverktyg
	Then a form for redigera metadata is displayed 
   
   Scenario: Kopiera metadata post
    Given that a post is open for editing
	When the user clicks the button to kopiera the post
	Then the post is given a new identifierare with the suffix "utkast_1" 
 	