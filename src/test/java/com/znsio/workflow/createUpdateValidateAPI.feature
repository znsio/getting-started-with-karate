@prod @createUpdateAlbumAPI

    # TARGET_ENVIRONMENT=prod TYPE=workflow TAG=@createUpdateAlbumAPI ./gradlew test
Feature: Create, update posts API

  Background:
    * def testData = read('classpath:com/znsio/templates/userData.json')

  @createPosts
  Scenario Outline: Create, update and validate posts with different data
    * def expectedTitle = <title>
    * def expectedBody = <body>
    * def expectedUserId = <userId>
    * def createPostsResponse = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_createPost',{"title": expectedTitle,"body": expectedBody,"userId": expectedUserId,"status": <status>}).response
    * match createPostsResponse == <expectedSchema>
    * match createPostsResponse.title == expectedTitle
    * match createPostsResponse.body == expectedBody
    * assert  createPostsResponse.userId == expectedUserId
    * def newTitle = <title>
    And def updateResponse = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_updateTitle',{"title": newTitle,"body": expectedBody,"userId": expectedUserId, "status": <new_status>}).response
    * match updateResponse == <expectedSchema>
    * match updateResponse.title == newTitle
    * match updateResponse.body == expectedBody
    * match updateResponse.userId == expectedUserId

    Examples:
      | userId                              | title                               | body                                | status | new_status | expectedSchema            |
      | 1                                   | generateAlphaNumericRandomString(5) | generateAlphaNumericRandomString(5) | 201    | 200        | testData.expectedResponse |
      | 2                                   | null                                | ""                                  | 201    | 200        | testData.expectedResponse |
      | 3                                   | generateRandomNumber(5)             | generateRandomNumber(5)             | 201    | 200        | testData.expectedResponse |
      | generateRandomNumber(5)             | generateAlphaNumericRandomString(5) | generateAlphaNumericRandomString(5) | 201    | 200        | testData.expectedResponse |
      | generateRandomNumber(5)             | ""                                  | null                                | 201    | 200        | testData.expectedResponse |
      | generateRandomNumber(5)             | generateRandomNumber(5)             | generateRandomNumber(5)             | 201    | 200        | testData.expectedResponse |
      | generateAlphaNumericRandomString(5) | generateAlphaNumericRandomString(5) | generateAlphaNumericRandomString(5) | 201    | 200        | testData.expectedResponse |
      | generateAlphaNumericRandomString(5) | null                                | null                                | 201    | 200        | testData.expectedResponse |
      | generateAlphaNumericRandomString(5) | generateRandomNumber(5)             | generateRandomNumber(5)             | 201    | 200        | testData.expectedResponse |
      | ""                                  | generateAlphaNumericRandomString(5) | generateAlphaNumericRandomString(5) | 201    | 200        | testData.expectedResponse |
      | null                                | generateAlphaNumericRandomString(5) | generateAlphaNumericRandomString(5) | 201    | 200        | testData.expectedResponse |

