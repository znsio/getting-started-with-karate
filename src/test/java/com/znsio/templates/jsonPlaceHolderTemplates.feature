Feature: Querying the API for posts and albums

  Background:
    Given url  env.dummyRestAPIUrl

  @t_getPosts
  Scenario: Get list af all posts
    Given path '/posts'
    And  params  query = query
    When method GET
    Then match responseStatus == expectedStatus

  @t_getAlbums
  Scenario: Get list of all albums
    Given path '/albums'
    And param userId = userId
    When method GET
    Then match responseStatus == expectedStatus

  @t_getComments
  Scenario: To validate the comments path
    Given path '/comments'
    And  params  query = query
    When method GET
    Then match responseStatus == expectedStatus

  @t_createPost
  Scenario: create new post
    Given path '/posts'
    And request '#(payload)'
    When method POST
    Then  match responseStatus == expectedStatus

  @t_updatePost
  Scenario: Update post
    Given path '/posts/1'
    And request '#(payload)'
    When method PUT
    Then match responseStatus == expectedStatus



