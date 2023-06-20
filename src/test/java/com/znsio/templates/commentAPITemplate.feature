@template
Feature: API tests for https://jsonplaceholder.typicode.com/

  Background:
    * def urlName = "https://jsonplaceholder.typicode.com"
    * url urlName

  @t_fetchComments
  Scenario: Get list of comments
    Given path "/comments"
    When method GET
    Then status 200
    And def comments = response
    * karate.log("comments response: ",response)


  @t_patchComments
  Scenario: patch comments
    * karate.log("requestBody--",requestBody)
    * def body = requestBody.body
    * def path = requestBody.path
    Given def requestPayload = {"body":  '#(body)'}
    And url url + path
    And request requestPayload
    When method put
    Then status 200
