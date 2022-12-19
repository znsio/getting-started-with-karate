@template
Feature: Template for creating User Posts

  Background:
    * url env.jsonPlaceholderUrl

  @t_createPost
  Scenario: Create User posts
    Given path '/posts'
    * request {"userId": "#(userId)", "title": "#(title)", "body": "#(body)"}
    When method POST
    Then match responseStatus == expectedStatus