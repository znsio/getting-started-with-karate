Feature: Querying the API for all posts and albums employees

  Background:
    Given url  env.dummyRestAPIUrl

  @t_getPostsEmployees
  Scenario: Get list of all employees posts with userId 1
    And path pathResources
    And params query
    When method GET
    Then status 200

  @t_getAlbumsEmployees
  Scenario: Get list of all employees albums with userId 1
    And path pathResources
    And params query
    When method GET
    Then status 200
