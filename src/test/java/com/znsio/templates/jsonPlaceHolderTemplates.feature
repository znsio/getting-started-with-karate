@template
Feature: Templates for jsonPlaceholder

  Background:
    Given url env.dummyRestAPIUrl

  @t_getAllPosts
  Scenario: Get All posts
    Given path '/posts/'+id
    When method GET
    Then match responseStatus == expectedStatus
    Then assert karate.sizeOf(response) > 0

  @t_getAllAlbums
  Scenario: Get All Albums
    Given path '/albums/'+id
    When method GET
    Then match responseStatus == expectedStatus
    Then assert karate.sizeOf(response) > 0
