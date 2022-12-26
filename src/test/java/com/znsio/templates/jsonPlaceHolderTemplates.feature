@template
Feature: Templates for ConfEngine

  Background:
    Given url env.dummyRestAPIUrl

  @t_getAllPosts
  Scenario: Get All posts
    And path '/posts'
    When method GET
    Then status 200
    Then print response
    Then assert response.length > 0

  @t_getAllAlbums
  Scenario: Get All posts
    And path '/albums'
    When method GET
    Then status 200
    Then assert response.length > 0
