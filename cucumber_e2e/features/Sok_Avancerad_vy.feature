@qa_ready
Feature: Avancerad sokning
  
  Scenario: Search with datum fran
    Given that the user is in Avancerad sokning
    When the user enters 2016 in the fran field
    Then Testpost_referensdatum_fran_Geodatasamverkan is listed 
  
  Scenario: Search with datum till
    Given that the user is in Avancerad sokning
    When the user enters 2015 in the till field
    Then Testpost_referensdatum_till_Geodatasamverkan is listed 

  Scenario: Search with datum fran and fritext 
    Given that the user is in Avancerad sokning 
    When the user enters 2016 in the datum fran field
    And the user enters Testpost_referensdatum_till_Geodatasamverkan_fritext in the fritext field
    Then Testpost_referensdatum_fran_fritext_Geodatasamverkan is listed 
	
  Scenario: Search with geografiskt omrade 
    Given that the user is in Avancerad sokning 
    When the user enters Östra goinge in the geografiskt omrade field
    Then Testpost_Geografi_lista_Geodatasamverkan is listed 
	
   Scenario: Search with geografiskt omrade and fritext
    Given that the user is in Avancerad sokning 
    When the user enters Östergotland in the geografiskt omrade field
    And the user enters Testpost_Geografi_karta_fritext_Geodatasamverkan in the fritext field
    Then Testpost_Geografi_karta_fritext_Geodatasamverkan is listed 
	
  Scenario: Search with direktatkomliga resurser
    Given that the user has filtering on 
    When the user selects Direktatkomliga resurser
    Then Testpost_Amne_direktatkomliga_resurser_Geodatasamverkan is listed
	
  Scenario: Search with karttjaanster
    Given that the user has filtering on
    When the user selects resurstyp Karttjanster
    Then Testpost_karttjanster_Geodatasamverkan is listed

  Scenario: Search with amne and initiativ
    Given that the user is in Avancerad sokning 
    When the user select amne Ekonomi
    And the user selects initiativ Geodatasamverkan
    Then Testpost_Amne_Initiativ_lista_Geodatasamverkan is listed
	
  Scenario: Search with amne and datum fran
    Given that the user is in Avancerad sokning 
    When the user select amne Ekonomi
    And the user enters 2016 in the datum fran field
    Then Testpost_Amne_lista_datum_Geodatasamverkan is listed
	 
  Scenario: Search with amne and geografiskt omrade 
    Given that the user is in Avancerad sokning 
    When the user select amne Ekonomi
    And the user enters Östergotland in the geografiskt omrade field
    Then Testpost_Amne_lista_fritext_Geodatasamverkan is listed
	 
  Scenario: Search with ansvarig
    Given that the user is in Avancerad sokning 
    When the user select ansvarig Testorganisation
    Then Testpost_Ansvarig_lista_Geodatasamverkan is listed

  Scenario: Search with ansvarig and fritext
    Given that the user is in Avancerad sokning 
    When the user select amne Ekonomi
    And the user enters Testpost_Ansvarig_lista_fritext_Geodatasamverkan in the fritext field
    Then Testpost_Amne_lista_fritext_Geodatasamverkan is listed

  Scenario: Search with amne and ansvarig
    Given that the user is in Enkel vy
    When the user select amne Ekonomi
    Then Testpost_Amne_Ansvarig_lista_Geodatasamverkan is listed
	
  Scenario: Search with resurstyp Datamangd
# oklart hur det ska fungera
    Given that the user is in Avancerad sokning 
    When the user select resurstyp Datamangd
    Then Testpost_Resurstyp_lista_fritext_Geodatasamverkan is listed

  Scenario: Search with resurstyp Datamangd and fritext
# oklart hur det ska fungera
    Given that the user is in Avancerad sokning 
    When the user select resurstyp Datamangd
    And the user enters Testpost_Resurstyp_lista_fritext_Geodatasamverkan in the fritext field
    Then Testpost_Resurstyp_lista_fritext_Geodatasamverkan is listed

  Scenario: Search with initiativ 
    Given that the user is in Avancerad sokning 
    When the user select initiativ Geodatasamverkan
    Then Testpost_Initiatv_lista_Geodatasamverkan is listed
	  
  Scenario: Search with initiativ and fritext
    Given that the user is in Avancerad sokning 
    When the user select initiativ Geodatasamverkan
    And the user enters Testpost_Initiativ_lista_fritext_Geodatasamverkan in the fritext field
    Then Testpost_Initiativ_lista_fritext_Geodatasamverkan is listed
	  