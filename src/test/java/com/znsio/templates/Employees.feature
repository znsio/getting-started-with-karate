Feature: Implementation for querying Employee APIs

  Background:
    Given url env.baseUrl

  @t_getEmployees @template
  Scenario: Get list of all employees
    Given path '/api/v1/employees'
    When method GET
    Then status 200
    * print response