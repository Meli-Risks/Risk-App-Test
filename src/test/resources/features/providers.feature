Feature: Proveedores
  Background:
    * url 'https://smart-risk.tech'
    * call read('login.feature')

  
  @provider
  Scenario Outline: Crear proveedor con errores de formato
    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And request { countryCodes: <countryCodes>, name: "<name>" }
    When method POST
    Then status 400
    And match response.code == 400
    And match response.message == "Error validando campos de entrada"
    And match response.details != null


    Examples:
      | countryCodes | name                  |
      | ""           |                       |
      | ""           | Proveedor 0 [TEST]    |
      | ["FR"]       |                       |
      | "FR"         | Proveedor 0 [TEST]    |
      | []           | Proveedor 0 [TEST]    |
      | ["US", "CA"] | P                     |

  
  @provider
  Scenario Outline: Crear proveedor con errores de negocio
    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And request { countryCodes: <countryCodes>, name: "<name>" }
    When method POST
    Then status 422
    And match response.code == 422
    And match response.message == "Algunos codigos de paises no existen"


    Examples:
      | countryCodes | name                 |
      | ["CO", "ZZ"] | Proveedor 0 [TEST]   |
      | ["UU"]       | Proveedor 0 [TEST]   |
      | ["US", "AA"] | Proveedor 0 [TEST]   |


  
  @provider
  Scenario Outline: Crear proveedores
    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And request { countryCodes: <countryCodes>, name: "<name>" }
    When method POST
    Then status 201
    And match response.code == 201
    And match response.message contains "creado exitosamente"
    And match response.data.countries contains only <countryCodes>
    And match response.data.name == "<name>"
    * def providerId = response.data.id

    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And path providerId
    When method DELETE


    Examples:
      | countryCodes              | name                 |
      | ["CO"]                    | Proveedor 1 [TEST]   |
      | ["CO", "FR"]              | Proveedor 2 [TEST]   |
      | ["US", "MX"]              | Proveedor 3 [TEST]   |
      | ["CO", "BR", "AR"]        | Proveedor 4 [TEST]   |
      | ["CO", "BR", "CA", "BB"]  | Proveedor 5 [TEST]   |

  
  @provider
  Scenario Outline: Actualizar proveedores no existentes
    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And path <providerId>
    And request { countryCodes: ["CO"], name: "Proveedor [ACTUALIZADO][TEST]" }
    When method PUT
    Then status 404
    And match response.code == 404
    And match response.message == "Proveedor no encontrado"

    Examples:
      | providerId  |
      | 0           |
      | 10000       |
      | 100000      |

  
  @provider
  Scenario Outline: Actualizar proveedor con errores de formato
    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And path 3
    And request { countryCodes: <countryCodes>, name: "<name>" }
    When method PUT
    Then status 400
    And match response.code == 400
    And match response.message == "Error validando campos de entrada"
    And match response.details != null


    Examples:
      | countryCodes | name                  |
      | ""           |                       |
      | "FR"         | Proveedor 0 [TEST]    |
      | []           | Proveedor 0 [TEST]    |
      | ["US", "CA"] | P                     |

  
  @provider
  Scenario Outline: Actualizar proveedor con errores de negocio
    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And path 3
    And request { countryCodes: <countryCodes>, name: "<name>" }
    When method PUT
    Then status 422
    And match response.code == 422
    And match response.message == "Algunos codigos de paises no existen"


    Examples:
      | countryCodes | name                 |
      | ["CO", "ZZ"] | Proveedor 0 [TEST]   |
      | ["UU"]       | Proveedor 0 [TEST]   |
      | ["US", "AA"] | Proveedor 0 [TEST]   |

  
  @provider
  Scenario Outline: Actualizar proveedores
    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And request { countryCodes: ["CO"], name: "Proveedor 1 [TEST]" }
    When method POST
    * def providerId = response.data.id

    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And path providerId
    And request { countryCodes: <countryCodes>, name: "<name>" }
    When method PUT
    Then status 200
    And match response.code == 200
    And match response.message contains "Proveedor actualizado exitosamente"
    And match response.data.countries contains only <countryCodes>
    And match response.data.name == "<name>"
    And match response.data.id == providerId

    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And path providerId
    When method DELETE


    Examples:
      | countryCodes              | name                          |
      | ["CO"]                    | Proveedor 1 [UPDATED][TEST]   |
      | ["CO", "FR"]              | Proveedor 2 [UPDATED][TEST]   |
      | ["US", "MX"]              | Proveedor 3 [UPDATED][TEST]   |
      | ["CO", "BR", "AR"]        | Proveedor 4 [UPDATED][TEST]   |

  
  @provider
  Scenario Outline: Eliminar proveedores no existentes
    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And path <providerId>
    When method DELETE
    Then status 404
    And match response.code == 404
    And match response.message == "Proveedor no encontrado"

    Examples:
      | providerId  |
      | 0           |
      | 10000       |
      | 100000      |

  
  @provider
  Scenario Outline: Eliminar proveedores
    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And request { countryCodes: ["CO"], name: "<name>" }
    When method POST
    * def providerId = response.data.id

    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And path providerId
    When method DELETE
    Then status 200
    And match response.code == 200
    And match response.message == "Proveedor eliminado exitosamente"

    Examples:
      | name                         |
      | Proveedor 1 [ELIMINAR][TEST] |
      | Proveedor 2 [ELIMINAR][TEST] |
      | Proveedor 3 [ELIMINAR][TEST] |


  @provider
  Scenario Outline: Buscar proveedores
    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And request { countryCodes: <countryCodes1>, name: "<name1>" }
    When method POST
    * def providerId1 = response.data.id

    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And request { countryCodes: <countryCodes2>, name: "<name2>" }
    When method POST
    * def providerId2 = response.data.id

    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And param id = providerId1
    When method GET
    Then status 200
    And match response.code == 200
    And match response.message == "Consulta exitosa"
    And eval if (response.data.content.length != 1) karate.abort("Cantidad incorrecta de proveedores")

    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And param name = <name>
    When method GET
    Then status 200
    And match response.code == 200
    And match response.message == "Consulta exitosa"
    And eval if (response.data.content.length < 2) karate.abort("Cantidad incorrecta de proveedores")

    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And path providerId1
    When method DELETE

    Given path 'api/v1/providers'
    And header Authorization = 'Bearer ' + accessToken
    And path providerId2
    When method DELETE


    Examples:
      | countryCodes1 | name1        | countryCodes2 | name2        | name     |
      | ["BL","AL"]   | XD1 [TEST1]  | ["DJ","AL"]   | RF2 [TEST1]  | [TEST1]  |
      | ["BL","AL"]   | LK2 [TEST2]  | ["DJ","AL"]   | GH2 [TEST2]  | [TEST2]  |
      | ["BL","AL"]   | OI1 [TEST3]  | ["DJ","AL"]   | JK2 [TEST3]  | [TEST3]  |
      | ["BL","AL"]   | PO1 [TEST4]  | ["DJ","AL"]   | QM2 [TEST4]  | [TEST4]  |