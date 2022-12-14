@template
Feature: Template for create and edit post

  Background: API url
    Given url env.dummyRestAPIUrl

  @t_createAPost
  Scenario: Create a post
    Given path '/posts'
    And request {"title": "#(title)","body": "#(body)","userId": "#(userId)"}
    When method POST
    Then status 201
    * def createPost = response
    * def Id = response.id
    And print 'created post: ' + response

  @t_fetchAPost
  Scenario: Fetch a post
    Given path '/posts/', id
    * print 'get post with id' + id
    When method GET
    Then status 200
    * def fetchPost = response
    And print 'posts from user with id: ' + id  + response

  @t_updatePostTitle
  Scenario: Update the post title
    Given path '/posts/', id
    And request {"id": "#(id)","title": "#(title)","body": "#(body)","userId": "#(userId)"}
    When method PATCH
    Then status 200
    * def updatePost = response
    And print 'updated post from user with id: ' + id + response


