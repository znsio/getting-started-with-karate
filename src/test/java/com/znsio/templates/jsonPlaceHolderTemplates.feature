@template
Feature: Template for fetch user posts and comments

  Background:
    * url env.jsonPlaceHolderUrl

  @t_getPostsById
  Scenario: Fetch posts for user with specific id
    Given path '/posts/' + userId
    When method GET
    Then match responseStatus == status
    And karate.log('posts from user with id ' + userId , response)


  @t_getCommentsById
  Scenario: Fetch comments for user with specific id
    Given path '/comments'
    And param postsId = userId
    When method GET
    Then match responseStatus == status
    And karate.log('comments from user with id ' + userId , response)


  @t_createPost
  Scenario: Create post for user
    Given path '/posts/'
    And request {"title": "#(title)","body": "#(body)","userId": "#(userId)"}
    When method POST
    Then match responseStatus == status
    And karate.log('posts for user with id ' ,response)

  @t_getAlbumsById
  Scenario: Get albums for user with specific user_id
    Given path '/albums'
    And param userId = userId
    When method GET
    Then match responseStatus == status
    And karate.log('albums for user with user_id ' + userId , response)

  @t_updateTitle
  Scenario: Update title
    Given path '/posts/' + userId
    And request {"title": "#(newTitle)","body": "#(body)","userId": "#(userId)"}
    When method PUT
    Then match responseStatus == status
    And karate.log('updated response ' , response.title)
