@template
Feature: Template for fetching User Posts

  Background:
    * url env.jsonPlaceholderUrl

  @t_getPost
  Scenario: Fetch User posts
    Given path '/posts/'
    * param userId = userId
    When method GET
    Then match responseStatus == expectedStatus