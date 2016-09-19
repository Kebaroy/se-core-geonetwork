@qa_ready
Feature: Visa metadata
  Scenario: VisaMetadataSomPublicerare
   	Given that the user has opened a post to redigera
 	When the user clicks on a link at the top
    Then metadata on the chosen tab is displayed
    
  Scenario: VisaMetadataSomAnvandare
   	Given that the user has clicked on the link to visa metadata
 	When the user clicks on a link at the top
    Then metadata on the chosen tab is displayed