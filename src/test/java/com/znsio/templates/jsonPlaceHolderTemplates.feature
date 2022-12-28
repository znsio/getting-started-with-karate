@template
Feature: Templates for jsonPlaceholder

  Background:
    Given url env.dummyRestAPIUrl

  @t_getAllPosts
  Scenario: Get All posts
    Given path '/posts/'
    And param userId = userId
    When method GET
    Then match responseStatus == expectedStatus

  @t_getAllAlbums
  Scenario: Get All Albums
    Given path '/albums/'
    And param userId = userId
    When method GET
    Then match responseStatus == expectedStatus

