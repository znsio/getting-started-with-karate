Feature: Implementation for querying Employee APIs

  Background:
    Given url env.dummyRestAPIUrl

  @t_getEmployees @template
  Scenario: Get list of all employees
    Given path '/todos/1'
    When method GET
    Then status 200
    * print response