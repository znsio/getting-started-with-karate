@template
Feature: Template for fetching User Albums

  Background:
    * url env.jsonPlaceholderUrl

  @t_getAlbums
  Scenario: Fetch User albums
    Given path '/albums'
    * param userId = userId
    When method GET
    Then match responseStatus == expectedStatus