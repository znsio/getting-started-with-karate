@sampleApi @prod
Feature: Create and edit post

  Background: API url
    Given url env.dummyRestAPIUrl

  Scenario: Create a post and fetch the created post
    Given path '/posts'
    And request {"title": "foo","body": "bar","userId": 11}
    When method POST
    Then status 201
    And assert response.id > 100
    And match response.id == '#number'
    And match response.userId == '#number'
    * def id = response.id

    Given path '/posts/', id
    When method GET
    Then status 200
    And match response.id == id
    And match response.id == '#number'
    And match response.userId == '#number'

      Scenario: Update the created post title and verify the title
        Given path '/posts/', 101
        And request {id: 101, title: 'foo2', body: 'bar', userId: 1}
        When method PATCH
        Then status 200
        And match response.title == 'foo2'
        And assert response.id > 100
        And match response.id == '#number'

