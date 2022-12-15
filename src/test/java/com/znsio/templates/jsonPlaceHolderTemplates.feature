@template
Feature: Template for fetch user posts and comments

  Background:
    * url env.jsonPlaceHolderUrl

  @t_getPostsById
  Scenario: Fetch posts for user with specific id
    Given path '/posts/' + userId
    When method GET
    Then status 200
    And print 'posts from user with id' + userId + response


  @t_getCommentsById
  Scenario: Fetch comments for user with specific id
    Given path '/comments'
    And param postId = userId
    When method GET
    Then status 200
    And print 'comments from user with id' + userId + response

  @t_createPost
  Scenario: Create post for user
    Given path '/posts'
    And request
    When method POST
    Then status 201

  @t_getAlbums
  Scenario: Get album details
    Given path '/albums'
    When method GET
    Then status 200
    And print 'albums for user' + response