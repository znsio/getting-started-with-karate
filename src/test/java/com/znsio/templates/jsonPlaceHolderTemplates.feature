Feature: Querying the API for posts and albums

  Background:
    Given url  env.dummyRestAPIUrl

  @t_getPosts
  Scenario: Get list af all posts
    Given path '/posts'
    And params '#(query)'
    When method GET
    Then match responseStatus == ecpectedStatus

  @t_getAlbums
  Scenario: Get list of all albums
    Given path '/albums'
    And params '#(query)'
    When method GET
    Then match responseStatus == ecpectedStatus

  @t_createPost
  Scenario: create new post
    Given path '/posts'
    And request '#(payload)'
    When method POST
    Then  match responseStatus == ecpectedStatus

  @t_updatePost
  Scenario: Update post
    Given path '/posts/1'
    And request '#(payload)'
    When method PUT
    Then match responseStatus == ecpectedStatus
