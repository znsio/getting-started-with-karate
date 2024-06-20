@template
Feature: Template for fetching User Comments

  Background:
    * url env.jsonPlaceholderUrl

  @t_getComments
  Scenario: Get User posts
    Given path '/posts/'
    * param postId = postId
    When method GET
    Then match responseStatus == expectedStatus