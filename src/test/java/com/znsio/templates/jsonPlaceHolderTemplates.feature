@template
Feature: Templates for jsonPlaceholder

  Background:
    Given url env.dummyRestAPIUrl

  @t_getAllPosts
  Scenario: Get All posts
    Given path '/posts/'
    And param userId = userId
    When method GET
    Then match responseStatus == expectedStatus

  @t_getPostsByParams
  Scenario: Get All posts
    Given path '/posts/'
    And params params
    When method GET
    * karate.log("Request url", karate.prevRequest.url)
    Then match responseStatus == expectedStatus

  @t_getPosts
  Scenario: Get posts
    Given path '/posts/'+id
    When method GET
    Then match responseStatus == expectedStatus

  @t_getAllAlbums
  Scenario: Get All Albums
    Given path '/albums/'
    And param userId = userId
    When method GET
    Then match responseStatus == expectedStatus

  @t_createPost
  Scenario: Create Post
    Given path '/posts/'
    And request body = body
    And header Content-Type = 'application/json'
    When method POST
    Then match responseStatus == expectedStatus

  @t_editPost
  Scenario: Edit Post
    Given path '/posts/'+id
    And request body = body
    And header Content-Type = 'application/json'
    When method PATCH
    Then match responseStatus == expectedStatus

  @t_getCommentsByParams
  Scenario: Get All posts
    Given path '/comments/'
    And params params
    When method GET
    * karate.log("Request url", karate.prevRequest.url)
    Then match responseStatus == expectedStatus
