@template
Feature: Template for fetch users posts and their comments

  Background: API url
    Given url env.dummyRestAPIUrl

  @t_getPostsById
  Scenario: Fetch all the posts for a user with id 1
    Given path 'posts/' + Id
    * print 'get users post with id: ' + Id
    When method GET
    Then status 200
    * def userPost = response
    And print 'posts from user with id: ' + Id  + response

    @t_getCommentsById
    Scenario: Fetch all the comments for a user with id 1
      Given path 'comments/' + Id
      * print 'get users comments with id' + Id
      When method GET
      Then status 200
      * def userComment = response
      And print 'comments from user with id: ' + Id  + response

