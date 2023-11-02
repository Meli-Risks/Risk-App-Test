Feature: Auth

  Background:
    * url 'https://smart-risk.tech'
    * call read('login.feature')

  @auth
  Scenario Outline: Prueba de inicio de sesión incorrecto
    Given path 'api/v1/login'
    And request { username: "<username>", password: "<password>" }
    When method POST
    Then status 401
    And match response == { code: 401, message: "Usuario o clave inválidos" }

    Examples:
      | username           | password |
      | notexist           | secret   |
      | other              | secret   |
      | none               | secret   |
      | jaider             | invalid  |
      | emily              | invalid  |
      | user               |          |
      |                    | pass     |
      |                    |          |


  @auth
  Scenario: Prueba de refreshToken
    Given path 'api/v1/refresh'
    And header Authorization = 'Bearer ' + refreshToken
    When method POST
    Then status 200
    And match response.accessToken != null

    Given path 'api/v1/logout'
    And header Authorization = 'Bearer ' + response.accessToken
    When method POST
    Then status 204


  @auth
  Scenario: Prueba de logout y revocado de token
    Given path 'api/v1/logout'
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 204

    Given path 'api/v1/logout'
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 401
    And match response.msg == "Token has been revoked"
