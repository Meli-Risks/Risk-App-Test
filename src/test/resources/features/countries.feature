Feature: Paises
  Background:
    * url 'https://smart-risk.tech'
    * call read('login.feature')

  @country
  Scenario: Obtener todos los países
    Given path 'api/v1/countries/all'
    And header Authorization = 'Bearer ' + accessToken
    When method GET
    Then status 200
    And match response.code == 200
    And match response.message == "Consulta exitosa"
    And eval if (response.data.length != 250) karate.abort("Cantidad incorrecta de registros en 'data'")
    And match response.data[0] == {code: '#string',flag: '#string',id: '#number',name: '#string'}

  @country
  Scenario Outline: Obtener países por códigos
    Given path 'api/v1/countries'
    And header Authorization = 'Bearer ' + accessToken
    And param codes = <codes>
    When method GET
    Then status 200
    And match response.code == 200
    And match response.message == "Consulta exitosa"
    And eval if (response.data.length != <records>) karate.abort("Cantidad incorrecta de registros en 'data'")
    And match each response.data contains {code: '#string', flag: '#string', id: '#number', name: '#string'}

    Examples:
      | codes                                | records |
      | ["CO", "BR"]                         | 2       |
      | ["US", "AR", "CA"]                   | 3       |
      | ["AU", "DE", "FR", "IT", "ES", "JP"] | 6       |

  @country
  Scenario Outline: Buscar pais o paises que no existen
    Given path 'api/v1/countries'
    And header Authorization = 'Bearer ' + accessToken
    And param codes = <codes>
    When method GET
    Then status 200
    And match response.code == 200
    And match response.message == "Consulta exitosa"
    And eval if (response.data.length != 0) karate.abort("Cantidad incorrecta de registros en 'data'")

    Examples:
      | codes               |
      | ["NN"]              |
      | ["AA", "WW"]        |
      | ["AA", "XX", "ZZ"]  |