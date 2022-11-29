@template
Feature: Create and edit post

  Background: API url
    Given url env.dummyRestAPIUrl

  @t_createAPost
  Scenario: Create a post
    Given path '/posts'
    And request {"title": "foo","body": "bar","userId": 11}
    When method POST
    Then status 201
    * def createPost = response
    * def Id = response.id
    And print 'created post: ' + response

  @t_fetchAPost
  Scenario: Fetch the created post
    * def ID = karate.call('classpath:com/znsio/templates/CreateAndEditThePostTemplates.feature@t_createAPost').Id
    * print 'ID: ' + ID
    Given path '/posts/', ID
    * print 'get post with id' + ID
    When method GET
    Then status 200
    * def fetchPost = response
    And print 'posts from user with id: ' + ID  + response

  @t_updatePostTitle
  Scenario: Update the created post title
    * def ID = karate.call('classpath:com/znsio/templates/CreateAndEditThePostTemplates.feature@t_createAPost').Id
    * print 'ID: ' + ID
    Given path '/posts/', ID
    And request {"id": 101,"title": "foo2","body": "bar","userId": 1}
    When method PATCH
    Then status 200
    * def updatePost = response
    And print 'updated post from user with id: ' + ID + response


