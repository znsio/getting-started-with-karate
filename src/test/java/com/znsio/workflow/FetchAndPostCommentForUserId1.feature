@FetchAndPostCommentForUserId1 @prod
Feature: Fetch users and their comments

  Background: API url
    Given url env.dummyRestAPIUrl
    * def Id = 1

  Scenario: Fetch all the posts for a user with id 1
    Given path 'posts/' + Id
    When method GET
    Then status 200
    And match response.id == Id
    And match response.id == '#number'

  Scenario: Fetch all the comments for a user with id 1
    Given path 'comments/' + Id
    When method GET
    Then status 200
    And match response.id == '#number'
    And match response.id == Id