@qa_ready
Feature: Skriv ut metadata post

  Scenario: SkrivUt
    Given that the user has chosen to visa metadata for a post
	When the user clicks on the button Skriv ut
	Then the metadata post is printed out