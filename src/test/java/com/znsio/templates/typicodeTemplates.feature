@template @prod
Feature: Templates for posts and albums

  Background:
    Given url env.dummyRestAPIUrl

  @t_getUserPosts
  Scenario: Get posts for user

    Given path 'posts'
    And param userId = userId
    When method GET
    Then match responseStatus == status_code
    And def posts = response

  @t_getUserAlbums
  Scenario: Get albums for user

    Given path 'albums'
    And param userId = userId
    When method GET
    Then match responseStatus == status_code
    And def albums = response