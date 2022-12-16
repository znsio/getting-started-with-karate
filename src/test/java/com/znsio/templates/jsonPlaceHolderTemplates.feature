@template
Feature: Template for fetch user posts and comments

  Background:
    * url env.jsonPlaceHolderUrl

  @t_getPostsById
  Scenario: Fetch posts for user with specific id
    Given path '/posts/' + userId
    When method GET
    Then status 200
    And karate.log('posts from user with id ' + userId , response)


  @t_getCommentsById
  Scenario: Fetch comments for user with specific id
    Given path '/comments'
    And param postId = userId
    When method GET
    Then status 200
    And karate.log('comments from user with id' + userId , response)


  @t_createPost
  Scenario: Create post for user
    Given path '/posts/'
    And request {"title": "#(title)","body": "#(body)","userId": "#(userId)"}
    When method POST
    Then status 201
    And karate.log('posts for user with id' ,response)

  @t_getAlbums
  Scenario: Get album details
    Given path '/albums'
    When method GET
    Then status 200
    And karate.log('albums for user' , response)

  @t_t_updateTitle
  Scenario: Update title
    Given path '/posts/' + userId
    When method PUT
    Then status 200
    And karate.log('updated response' , response.title)
