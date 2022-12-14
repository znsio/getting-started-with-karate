Feature: Fetching user details

  Background:
    * print "base url "+env.baseUrl
    Given url env.baseUrl

  @t_getPost
  Scenario: Get Posts for particular user id
    Given path "/posts/"+userId
    When method Get
    Then status 200
    * def listOfPosts = response

  @t_getComment
  Scenario: Get Comments for particular user id
    Given path "/comments/"+userId
    When method Get
    Then status 200
    * def listOfComments = response

  @t_getPosts
  Scenario: Get Posts for all the user
    And path '/posts'
    When method Get
    Then status 200
    * def posts = response

  @t_getComments
  Scenario: Get Comments for all the user
    And path '/comments'
    When method Get
    Then status 200
    * def comments = response

  @t_CreatePost
  Scenario: Create new post
    And path '/posts'
    And request {"title": '#(title)',"body": '#(body)',"userId": '#(userId)'}
    When method Post
    Then status 201
    * def post = response

  @t_EditPost
  Scenario: Edit already created post
    And path '/posts/'+id
    And request input
    When method Patch
    Then status 200
    * def edit = response

