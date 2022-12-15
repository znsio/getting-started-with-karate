@template
Feature: Template for User Posts and Comments

  Background:
    * url env.jsonPlaceholderUrl

  @t_getPost
  Scenario: Get User posts
    Given path '/posts/' + userId
    When method GET
    Then match responseStatus == expectedStatus
    * print "response", response

  @t_getAlbums
  Scenario: Get User albums
    Given path '/albums'
    * param userId = userId
    When method GET
    Then match responseStatus == expectedStatus
    * print "response",response

  @t_createPost
  Scenario: Create User posts
    Given path '/posts'
    * request {"userId": "#(userId)", "title": "#(title)", "body": "#(body)"}
    When method POST
    Then match responseStatus == expectedStatus
    * print "response",response

  @t_updatePost
  Scenario: Create User posts
    Given path '/posts/' + userId
    * request {"title": "Kanishk Jain"}
    When method PUT
    Then match responseStatus == expectedStatus
    * print "response",response