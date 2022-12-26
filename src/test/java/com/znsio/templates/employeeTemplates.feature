Feature: Implementation for querying Employee APIs

  Background:
    * print "env.dummyRestAPIUrl: " + env.dummyRestAPIUrl
    Given url env.dummyRestAPIUrl
    * def query = {userId:'1'}

  @t_getEmployees @template
  Scenario: Get list of all employees
    * print "Get list for employeeId with userId=1"
    * def updatedPath = pathResources
    And params query
    Given path updatedPath
    When method GET
    Then status 200
    * print response

