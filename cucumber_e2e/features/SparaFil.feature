@qa_ready
Feature: Spara fil

  Scenario: Oppna post that is to be saved lokalt as xmlfil 
    Given that the user is in publishing mode
	When the user clicks on the redigera alternativ on the list Publicerarverktyg
	Then a form for redigera metadata is displayed 
   
   Scenario: Spara xmlfil lokalt
    Given that a post is open for editing
	When the user clicks the button to spara xmlfil lokalt
	Then a browse dialog is displayed where the user selects where to save the file
	
   Scenario: Spara som ISO_19139
    Given that the user is in publishing mode
	When the user clicks on the spara som iso 19139 on the list Publicerarverktyg
	Then a message is displayed that the file is saved
	# eller vad ska hända?
	
  Scenario: Spara som dcat
    Given that the user is in publishing mode
	When the user clicks on the spara som dcat alternativ on the list Publicerarverktyg
	Then a message is displayed that the file is saved
	# eller vad ska hända?
	