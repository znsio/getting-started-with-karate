@template
Feature: Template for User Posts and Comments

  Background:
    * url env.jsonPlaceholderUrl

  @t_getPost
  Scenario: Get User posts
    Given path '/posts/'
    * param userId = userId
    When method GET
    * match responseStatus == expectedStatus
    * print "response", response

  @t_getAlbums
  Scenario: Get User albums
    Given path '/albums'
    * param userId = userId
    When method GET
    Then match responseStatus == expectedStatus
    * print "response",response