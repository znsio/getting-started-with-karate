@template
Feature: Template for updating User Posts

  Background:
    * url env.jsonPlaceholderUrl

  @t_updatePost
  Scenario: Create User posts
    Given path '/posts/' + userId
    * request {"title": "#(title)"}
    When method PUT
    Then match responseStatus == expectedStatus