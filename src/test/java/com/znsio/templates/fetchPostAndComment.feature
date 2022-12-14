@template
Feature: Template for User Posts and Comments

  Background:
    * url env.jsonPlaceholderUrl

  @t_getPost
  Scenario: Get User posts
    Given path '/posts/' + userId
    When method GET
    Then status 200
    * print "response", response

  @t_getComments
  Scenario: Get User comments
    Given path '/comments'
    * param postId = userId
    When method GET
    Then status 200
    * print "response",response