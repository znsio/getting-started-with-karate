@template
Feature: API tests for https://jsonplaceholder.typicode.com/

  Background: api url
    * url "https://jsonplaceholder.typicode.com"

  @t_fetchComments
  Scenario: Get list of comments
    Given path "/comments"
    When method GET
    Then status 200
    And def comments = response
    * print response

