@qa_ready
Feature: Hantera favoriter
  
  Scenario: Create favorit
    Given that the user has chosen to visa filtering
    When the user clicks the star next to a post title that does not have a star 
    Then the post is added as a favorit
    
  Scenario: Show favoriter
    Given that the user has chosen to visa filtering
    When the user clicks the link to favoriter  
    Then all posts that are favoriter are shown in the result list

  Scenario: Ta bort favorit
    Given that the user has chosen to visa filtering
    When the user clicks the star next to a post title that has a star 
    Then the post is removed as a favorit
    