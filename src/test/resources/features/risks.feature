Feature: Riesgos
  Background:
    * url 'https://smart-risk.tech'
    * call read('login.feature')


  @risk
  Scenario Outline: Crear riesgo con errores de formato
    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And request {countryCode: "<countryCode>",description: "<description>",impact: <impact>,probability: <probability>,providerId: <providerId>,title: "<title>"}
    When method POST
    Then status 400
    And match response.code == 400
    And match response.message == "Error validando campos de entrada"
    And match response.details != null


    Examples:
      | countryCode  | title                    | description                  | impact | probability | providerId |
      |              | Riesgo0 [TEST]           | Riesgo0 desc [TEST]          | 1      | 1           | 1          |
      | C            | Riesgo0 [TEST]           | Riesgo0 desc [TEST]          | 1      | 1           | 1          |
      | CCC          | Riesgo0 [TEST]           | Riesgo0 desc [TEST]          | 1      | 1           | 1          |
      | CO           |                          | Riesgo0 desc [TEST]          | 1      | 1           | 1          |
      | CO           | Ri                       | Riesgo0 desc [TEST]          | 1      | 1           | 1          |
      | CO           | Riesgo0 [TEST]           |                              | 1      | 1           | 1          |
      | CO           | Riesgo0 [TEST]           | Riesgo                       | 1      | 1           | 1          |
      | CO           | Riesgo0 [TEST]           | Riesgo0 desc [TEST]          | ""     | 1           | 1          |
      | CO           | Riesgo0 [TEST]           | Riesgo0 desc [TEST]          | 9      | 1           | 1          |
      | CO           | Riesgo0 [TEST]           | Riesgo0 desc [TEST]          | 2      | "b"         | 1          |
      | CO           | Riesgo0 [TEST]           | Riesgo0 desc [TEST]          | 2      | 7           | 1          |
      | CO           | Riesgo0 [TEST]           | Riesgo0 desc [TEST]          | 3      | 3           | "c"        |


  @risk
  Scenario Outline: Crear riesgo con errores de negocio
    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And request {countryCode: "<countryCode>",description: "<description>",impact: <impact>,probability: <probability>,providerId: <providerId>,title: "<title>"}
    When method POST
    Then status 422
    And match response.code == 422
    And match response.message == "Pais no encontrado para este proveedor"

    Examples:
      | countryCode  | title                    | description                  | impact | probability | providerId |
      | TZ           | Riesgo0 [TEST]           | Riesgo0 desc [TEST]          | 3      | 3           | 1          |
      | TZ           | Riesgo0 [TEST]           | Riesgo0 desc [TEST]          | 3      | 3           | 2          |


  @risk
  Scenario Outline: Crear riesgos
    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And request {countryCode: "<countryCode>",description: "<description>",impact: <impact>,probability: <probability>,providerId: <providerId>,title: "<title>"}
    When method POST
    Then status 201
    And match response.code == 201
    And match response.message contains "creado exitosamente"
    And match response.data.country == "<countryCode>"
    And match response.data.title == "<title>"
    And match response.data.description == "<description>"
    And match response.data.impact == <impact>
    And match response.data.probability == <probability>
    And match response.data.providerId == <providerId>
    * def riskId = response.data.id

    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And path riskId
    When method DELETE

    Examples:
      | countryCode  | title                    | description                  | impact | probability | providerId |
      | AR           | Riesgo1 [TEST]           | Riesgo1 desc [TEST]          | 1      | 2           | 1          |
      | BR           | Riesgo2 [TEST]           | Riesgo2 desc [TEST]          | 3      | 4           | 2          |
      | MX           | Riesgo3 [TEST]           | Riesgo3 desc [TEST]          | 5      | 5           | 3          |


  @risk
  Scenario Outline: Actualizar riesgos no existentes
    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And path <providerId>
    And request {countryCode: "AR",description: "description",impact: 1,probability: 1,providerId: 1,title: "title"}
    When method PUT
    Then status 404
    And match response.code == 404
    And match response.message == "Riesgo no encontrado"

    Examples:
      | providerId  |
      | 0           |
      | 10000       |
      | 100000      |


  @risk
  Scenario Outline: Actualizar riesgo con errores de formato
    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And path 6
    And request {countryCode: "<countryCode>",description: "<description>",impact: <impact>,probability: <probability>,providerId: <providerId>,title: "<title>"}
    When method PUT
    Then status 400
    And match response.code == 400
    And match response.message == "Error validando campos de entrada"
    And match response.details != null

    Examples:
      | countryCode  | title                    | description                  | impact | probability | providerId |
      | C            | Riesgo0 [TEST]           | Riesgo0 desc [TEST]          | 1      | 1           | 1          |
      | CCC          | Riesgo0 [TEST]           | Riesgo0 desc [TEST]          | 1      | 1           | 1          |
      | CO           | Ri                       | Riesgo0 desc [TEST]          | 1      | 1           | 1          |
      | CO           | Riesgo0 [TEST]           | Riesgo                       | 1      | 1           | 1          |
      | CO           | Riesgo0 [TEST]           | Riesgo0 desc [TEST]          | 9      | 1           | 1          |
      | CO           | Riesgo0 [TEST]           | Riesgo0 desc [TEST]          | 2      | "b"         | 1          |
      | CO           | Riesgo0 [TEST]           | Riesgo0 desc [TEST]          | 2      | 7           | 1          |
      | CO           | Riesgo0 [TEST]           | Riesgo0 desc [TEST]          | 3      | 3           | "c"        |


  @risk
  Scenario Outline: Actualizar riesgo con errores de negocio
    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And path 6
    And request {countryCode: "<countryCode>",providerId: <providerId>}
    When method PUT
    Then status 422
    And match response.code == 422
    And match response.message == "Pais no encontrado para este proveedor"

    Examples:
      | countryCode  | providerId |
      | TZ           | 1          |
      | TZ           | 2          |


  @risk
  Scenario Outline: Actualizar riesgos
    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And request {countryCode: "AR",description: "description",impact: 2,probability: 2,providerId: 1,title: "title"}
    When method POST
    * def riskId = response.data.id

    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And path riskId
    And request {countryCode: "<countryCode>",description: "<description>",impact: <impact>,probability: <probability>,providerId: <providerId>,title: "<title>"}
    When method PUT
    Then status 200
    And match response.code == 200
    And match response.message == "Riesgo actualizado exitosamente"
    And match response.data.country == "<countryCode>"
    And match response.data.title == "<title>"
    And match response.data.description == "<description>"
    And match response.data.impact == <impact>
    And match response.data.probability == <probability>
    And match response.data.providerId == <providerId>
    And match response.data.id == riskId

    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And path riskId
    When method DELETE


    Examples:
      | countryCode  | title                    | description                  | impact | probability | providerId |
      | AR           | Riesgo1 [TEST]           | Riesgo1 desc [TEST]          | 1      | 2           | 1          |
      | BR           | Riesgo2 [TEST]           | Riesgo2 desc [TEST]          | 3      | 4           | 2          |
      | MX           | Riesgo3 [TEST]           | Riesgo3 desc [TEST]          | 5      | 5           | 3          |


  @risk
  Scenario Outline: Eliminar riesgos no existentes
    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And path <providerId>
    When method DELETE
    Then status 404
    And match response.code == 404
    And match response.message == "Riesgo no encontrado"

    Examples:
      | providerId  |
      | 0           |
      | 10000       |
      | 100000      |


  @risk
  Scenario Outline: Eliminar riesgos
    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And request {countryCode: "AR",description: "description",impact: 2,probability: 2,providerId: 1,title: "<name>"}
    When method POST
    * def riskId = response.data.id

    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And path riskId
    When method DELETE
    Then status 200
    And match response.code == 200
    And match response.message == "Riesgo eliminado exitosamente"

    Examples:
      | name                      |
      | Riesgo 1 [ELIMINAR][TEST] |
      | Riesgo 2 [ELIMINAR][TEST] |
      | Riesgo 3 [ELIMINAR][TEST] |
    
    
  @risk
  Scenario Outline: Buscar riesgos
    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And request {countryCode: "<countryCode>",description: "<description>",impact: <impact>,probability: <probability>,providerId: <providerId>,title: "<title1>"}
    When method POST
    * def riskId1 = response.data.id

    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And request {countryCode: "<countryCode>",description: "<description>",impact: <impact>,probability: <probability>,providerId: <providerId>,title: "<title2>"}
    When method POST
    * def riskId2 = response.data.id

    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And param id = riskId1
    When method GET
    Then status 200
    And match response.code == 200
    And match response.message == "Consulta exitosa"
    And eval if (response.data.content.length != 1) karate.abort("Cantidad incorrecta de riesgos")

    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And param title = "title"
    And param description = "<description>"
    And param impact = <impact>
    And param probability = <probability>
    And param provider.id = <providerId>
    And param country.code = "<countryCode>"
    When method GET
    Then status 200
    And match response.code == 200
    And match response.message == "Consulta exitosa"
    And eval if (response.data.content.length != 2) karate.abort("Cantidad incorrecta de riesgos")

    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And param globalFilter = "<globalFilter1>"
    When method GET
    Then status 200
    And match response.code == 200
    And match response.message == "Consulta exitosa"
    And eval if (response.data.content.length != 2) karate.abort("Cantidad incorrecta de riesgos")

    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And param globalFilter = "<globalFilter2>"
    When method GET
    Then status 200
    And match response.code == 200
    And match response.message == "Consulta exitosa"
    And eval if (response.data.content.length != 2) karate.abort("Cantidad incorrecta de riesgos")

    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And path riskId1
    When method DELETE

    Given path 'api/v1/risks'
    And header Authorization = 'Bearer ' + accessToken
    And path riskId2
    When method DELETE

    Examples:
      | countryCode  | description          | title1         | title2         | impact | probability | providerId | globalFilter1 |  globalFilter2 |
      | AR           | unf[dsf-desc [TEST]  | gnf[dsf-title  | title-gnf[dsf  | 1      | 2           | 1          | gnf[dsf       |  [TEST]        |
      | BR           | ubf!vlg-desc [TEST]  | jbf!vlg-title  | title-jbf!vlg  | 3      | 4           | 2          | jbf!vlg       |  title         |
      | MX           | ugf.dfs-desc [TEST]  | hgf.dfs-title  | title-hgf.dfs  | 5      | 5           | 3          | hgf.dfs       |  -desc         |
