Feature: Querying the API for all posts and albums employees

  Background:
    Given url  env.dummyRestAPIUrl

    * def query = {userId:'1'}


  @t_getPostsEmployees
  Scenario: Get list of all employees posts with userId 1
    And path '/posts'
    And params query
    When method GET
    Then match status 200



  @t_getAlbumsEmployees
  Scenario: Get list of all employees albums with userId 1
    And path '/albums'
    And params query
    When method GET
    Then status 200
