Feature: Login

  Background:
    * url 'https://smart-risk.tech'
    * def accessToken = null
    * def refreshToken = null


  Scenario: Iniciar sesión y establecer token
    Given path 'api/v1/login'
    And request { username: "jaider", password: "654321" }
    When method POST
    Then status 200
    And match response.accessToken != null
    And match response.refreshToken != null
    * def accessToken = response.accessToken
    * def refreshToken = response.refreshToken
