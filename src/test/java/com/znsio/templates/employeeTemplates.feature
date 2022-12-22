Feature: Implementation for querying Employee APIs

  Background:
    * print "env.dummyRestAPIUrl: " + env.dummyRestAPIUrl
    Given url env.dummyRestAPIUrl

  @t_getEmployees @template
  Scenario: Get list of all employees
    * print "Get list for employeeId with userId=1"
    * def updatedPath = "/posts"
    Given path updatedPath
    When method GET
    Then status 200
    * print response

  @t_getAlbum @template
  Scenario: Get list of all employees
    * print "Get list for employeeId with userId=1"
    * def updatedPath = "/albums"
    Given path updatedPath
    When method GET
    Then status 200
    * print response