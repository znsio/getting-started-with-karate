@template
Feature: Template for create and edit post

  Background: API url
    Given url env.dummyRestAPIUrl

  @t_createAPost
  Scenario: Create a post
    Given path '/posts'
    And request {"title": "#(title)","body": "#(body)","userId": #(userId)}
    When method POST
    Then status 201
    * def createPost = response
    * def Id = response.id
    And print 'created post: ' + response

  @t_fetchAPost
  Scenario: Fetch a post
    * def ID = karate.call('classpath:com/znsio/templates/CreateAndEditThePostTemplates.feature@t_createAPost').Id
    Given path '/posts/', ID
    * print 'get post with id' + ID
    When method GET
    Then status 200
    * def fetchPost = response
    And print 'posts from user with id: ' + ID  + response

  @t_updatePostTitle
  Scenario: Update the post title
    * def ID = karate.call('classpath:com/znsio/templates/CreateAndEditThePostTemplates.feature@t_createAPost').Id
    Given path '/posts/', ID
    And request {"id": "#(id)","title": "#(title)","body": "#(body)","userId": "#(userId)"}
    When method PATCH
    Then status 200
    * def updatePost = response
    And print 'updated post from user with id: ' + ID + response


