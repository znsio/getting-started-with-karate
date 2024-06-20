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

  @t_fetchPosts
  Scenario: Get posts for user with query params

    Given path 'posts'
    And params query_params
    When method GET
    Then match responseStatus == status_code

  @t_getUserAlbums
  Scenario: Get albums for user

    Given path 'albums'
    And param userId = userId
    When method GET
    Then match responseStatus == status_code

  @t_createPosts
  Scenario: Create post for user

    Given path 'posts'
    And header Content-Type = 'application/json'
    And request createPostPayload
    When method POST
    Then match responseStatus == status_code

  @t_getPosts
  Scenario: Fetch post

    Given path 'posts', postId
    * print postId
    When method GET
    Then match responseStatus == status_code

  @t_editPosts
  Scenario: Edit post for user

    Given path 'posts', postId
    And header Content-Type = 'application/json'
    And request editPostPayload
    When method PATCH
    Then match responseStatus == status_code