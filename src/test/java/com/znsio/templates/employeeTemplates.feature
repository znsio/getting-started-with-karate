Feature: Implementation for querying Employee APIs

  Background:
    * print "env.dummyRestAPIUrl: " + env.dummyRestAPIUrl
    Given url env.dummyRestAPIUrl

  @t_getEmployees @template
  Scenario: Get list of all employees
    * print "Get list for employeeId: " + empId
    * def updatedPath = "/todos/" + empId
    Given path updatedPath
    When method GET
    Then status 200
    * print response