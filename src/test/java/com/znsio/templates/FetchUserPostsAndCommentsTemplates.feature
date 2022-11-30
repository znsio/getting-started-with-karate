@template
Feature: Template for fetch users posts and their comments

  Background: API url
    Given url env.dummyRestAPIUrl

  @t_getPostsById
  Scenario: Fetch all the posts for a user with id
    Given path 'posts/' + userWithId
    * print 'get users post with id: ' + userWithId
    When method GET
    Then status 200
    * def userPost = response
    And print 'posts from user with id: ' + userWithId  + response

    @t_getCommentsById
    Scenario: Fetch all the comments for a user with id
      Given path 'comments/' + userWithId
      * print 'get users comments with id' + userWithId
      When method GET
      Then status 200
      * def userComment = response
      And print 'comments from user with id: ' + userWithId  + response

