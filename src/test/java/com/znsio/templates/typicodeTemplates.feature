@template @prod
Feature: api tests for 'https://jsonplaceholder.typicode.com'

  Background:
    * url env.dummyRestAPIUrl

  @t_getUserDetails
  Scenario: Fetch all the details for a user with given user id

    * path dataType
    * param userId = userId
    * method GET
    * status 200
    * def data = response
