Feature: Sokning i enkel vy

	Scenario: Search with fritext on titel
    Given that the user is in Enkel vy
	When the user enters the text Testpost_fritext_titel_Geodatasamverkan in the fritext field
	Then Testpost_fritext_titel_Geodatasamverkan is listed


	Scenario: Search with fritext on alternativ titel
    Given that the user is in Enkel vy
	When the user enters the text Testpost_fritext_titel_Alternativtitel_Geodatasamverkan in the fritext field
	Then Testpost_fritext_titel_Alternativ_titel_Geodatasamverkan is listed

	@qa_ready
	Scenario: Search with fritext on sammanfattning
    Given that the user is in Enkel vy
	When the user enters the text Testpost_fritext_faalt_sammanfattning_Geodatasamverkan in the fritext field
	Then Testpost_fritext_faalt_samman_fattning_Geodatasamverkan is listed

@qa_ready
	Scenario: Search with fritext on tva ord in the titel
    Given that the user is in Enkel vy
	When the user enters the text "Testpost_fritext_titel_tva_ord exakt_Geodatasamverkan" in the fritext field
	Then "Testpost_fritext_titel_tva_ord exakt_Geodatasamverkan" is listed

@qa_ready
	Scenario: Search with amne
    Given that the user is in Enkel vy
    When the user select amne "ECONOMY"
    Then Testpost_Aamne_lista_Geodatasamverkan is listed

@qa_ready
	Scenario: Search with amne and fritext
    Given that the user is in Enkel vy
    When the user combine amne "ECONOMY" with entering the text Testpost_aamne_lista_fritext_Geodatasamverkan in the fritext field
    Then Testpost_Aamne_lista_fritext_Geodatasamverkan is listed
