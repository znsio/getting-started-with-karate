@template
Feature: Template for User Posts and Comments

  Background:
    * url env.jsonPlaceholderUrl

  @t_getPost
  Scenario: Get User posts
    Given path '/posts/'
    * param userId = userId
    When method GET
    Then match responseStatus == expectedStatus

  @t_getAlbums
  Scenario: Get User albums
    Given path '/albums'
    * param userId = userId
    When method GET
    Then match responseStatus == expectedStatus

  @t_createPost
  Scenario: Create User posts
    Given path '/posts'
    * request {"userId": "#(userId)", "title": "#(title)", "body": "#(body)"}
    When method POST
    Then match responseStatus == expectedStatus

  @t_updatePost
  Scenario: Create User posts
    Given path '/posts/' + userId
    * request {"title": "#(title)"}
    When method PUT
    Then match responseStatus == expectedStatus

  @t_getComments
  Scenario: Get User posts
    Given path '/posts/'
    * param postId = postId
    When method GET
    Then match responseStatus == expectedStatus