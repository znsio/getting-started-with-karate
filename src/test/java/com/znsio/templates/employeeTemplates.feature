Feature: Implementation for querying Employee APIs

  Background:
    * karate.log("env.dummyRestAPIUrl: " + env.dummyRestAPIUrl)
    Given url env.dummyRestAPIUrl

  @t_getEmployees @template
  Scenario: Get list of all employees
    * karate.log("Get list for employeeId: " + empId)
    * def updatedPath = "/todos/" + empId
    Given path updatedPath
    When method GET
    Then status 200
    * karate.log('Response',response)