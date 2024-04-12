Feature: Implementation for querying Employee APIs

  Background:
    Given print "env.dummyRestAPIUrl: " + env.dummyRestAPIUrl
    And url env.dummyRestAPIUrl

  @t_getEmployees @template
  Scenario: Get list of all employees
    Given print "Get list for employeeId: ",empId
    And def updatedPath = "/todos/" + empId
    And path updatedPath
    When method GET
    Then status 200
    And print "List of employees: \n", response
    And json employeeDetails = response
    And match employeeDetails.id == empId
