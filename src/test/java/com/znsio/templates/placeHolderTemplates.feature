@template
Feature: Templates for jsonPlaceHolder

  Background:
    Given url env.jsonPlaceHolderUrl
#    * print "URL IS "  url

  @t_getPostByUserId
  Scenario: Get all the posts with specific userId
    Given path 'posts/' + userId
    * print "Get all posts with userId as " + userId
#    * print "url is " + url
    When method GET
    Then status 200
    * print "Post found: " + response
    * def postsResponse = response

  @t_getCommentsByUserId
  Scenario: Get all the comments with specific userId
    Given path 'comments'
    And param id = userId
    When method GET
    Then status 200
    * print "Number of comments found: " + response.length
    * print "comments found: " + response
    * def commentsResponse = response
