@jsonPlaceholder @prod
Feature: Test jsonPlaceholder APIs

  Scenario Outline: Fetch posts for a user with different query parameters

    Given def listOfPosts = karate.call('classpath:com/znsio/templates/typicodeTemplates.feature@t_fetchPosts', {query_params: {<Key> : <Value>}, status_code: 200})
    * karate.log("User posts with invalid query params : " , listOfPosts)
    Then assert listOfPosts.response.length >= 0

    Examples:
      | Key     | Value                                        |
      | userId  | 1                                            |
      | userId  | -123                                         |
      | userId  | null                                         |
      | id      | 12                                           |
      | id      | -1                                           |
      | id      | null                                         |
      | title   | jsonPlaceholder.testData.validTestData.title |
      | body    | jsonPlaceholder.testData.validTestData.body  |
      | title   | generateAlphaNumericRandomString(10)         |
      | body    | generateAlphaNumericRandomString(10)         |
      | invalid | generateRandomNumber(10)                     |

  Scenario Outline: Fetch posts for a user with different post id

    Given def listOfPosts = karate.call('classpath:com/znsio/templates/typicodeTemplates.feature@t_getPosts', {postId: "<postId>", status_code: <responseStatus>})
    * karate.log("User posts with invalid postId : " , listOfPosts)
    Then match listOfPosts.response == <response>

    Examples:
      | postId | responseStatus | response                                              |
      | 1      | 200            | jsonPlaceholder.testData.validTestData                |
      | -1     | 404            | jsonPlaceholder.testData.invalidTestData.nullTestData |
      | xyz    | 404            | jsonPlaceholder.testData.invalidTestData.nullTestData |
      | #abc%$ | 404            | jsonPlaceholder.testData.invalidTestData.nullTestData |