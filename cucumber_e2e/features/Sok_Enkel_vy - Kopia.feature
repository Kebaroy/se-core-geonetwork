@qa_ready
Feature: Sokning i enkel vy
  
  Scenario: Search with 1 Amne 
    Given that the user is in Enkel vy 
	And filter is shown
    When the user selects Amne Geovetenskap
    Then Testpost_1_Amne_Geodatasamverkan, Testpost_1_Amne_Oppna_data, Testpost_1_Amne_Inspire are listed 

  Scenario: Search with 2 Amnen
    Given that the user is in Enkel vy
    And filter is shown
	When the user selects Amne Biologi och ekologi 
    And the user selects Amne Kust och hav
    Then Testpost_2_Amnen_Geodatasamverkan, Testpost_2_Amnen_Oppna_data, Testpost_2_Amnen_Inspire are listed 
  
   Scenario: Search with 1 Amne and fritext 
    Given that the user is in Enkel vy 
	And filter is shown
    When the user clicks Amne Geovetenskap
	And enters the text Testpost_1_Amne_fritext_titel_Geodatasamverkan in the fritext field 
	Then Testpost_1_Amne_fritext_titel_Geodatasamverkan is listed
	
//   Scenario: Search with fritext on titel
//    Given that the user is in Enkel vy 
//	When the user enters the text Testpost_fritext_titel_Geodatasamverkan in the fritext field 
//	Then Testpost_fritext_titel_Geodatasamverkan is listed

//   Scenario: Search with fritext on alternativ titel
//    Given that the user is in Enkel vy 
//	When the user enters the text Testpost_alternativ_titel_Geodatasamverkan in the fritext field 
//	Then Testpost_alternativ_titel_Geodatasamverkan is listed

//   Scenario: Search with fritext on sammanfattning
//    Given that the user is in Enkel vy 
//	When the user enters the text Testpost_fritext_fAlt_sammanfattning_Geodatasamverkan in the fritext field 
//	Then Testpost_fritext_fAlt_sammanfattning_Geodatasamverkan is listed

//   Scenario: Search with fritext on exactly 1 word in the titel 
//    Given that the user is in Enkel vy 
//	When the user enters the text "Testpost_fritext_titel_1_ord_exakt_Geodatasamverkan" in the fritext field 
//	Then Testpost_fritext_titel_1_ord_exakt_Geodatasamverkan is listed

// Scenario: Search with fritext on 2 words in the titel 
//    Given that the user is in Enkel vy 
//	When the user enters the text Testpost_fritext_titel _2_ord_exakt_Geodatasamverkan in the fritext field 
//	Then Testpost_fritext_titel_2_ord_exakt_Geodatasamverkan is listed

    Scenario: Change Amne
    Given that the user is in Enkel vy 
    And the user has clicked Amne Geovetenskap
    When the user deselects Amne Geovetenskap
    And clicks Amne Ekonomi 
    Then Titel=Testpost_Amne_lista_Geodatasamverkan is listed
    And Testpost_1_Amne_Geodatasamverkan is not listed
    
	 