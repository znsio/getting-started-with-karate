@prod @createUpdateAlbumAPI

    # TARGET_ENVIRONMENT=prod TYPE=workflow TAG=@createUpdateAlbumAPI ./gradlew test
Feature: Create, update posts API

  Background:
    * def testData = read('classpath:com/znsio/templates/userData.json')

  @createPosts
  Scenario Outline: Create posts with different data
    * def expectedTitle = <title>
    * def expectedBody = <body>
    * def expectedUserId = <userId>
    * def createPostsResponse = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_createPost',{"title": title,"body": body,"userId": userId,"status": <status>}).response
    * match createPostsResponse == <expectedSchema>
    * match createPostsResponse.title == expectedTitle
    * match createPostsResponse.body == expectedBody
    * match createPostsResponse.userId == expectedUserId

    Examples:
      | userId                              | title                               | body                                | status | expectedSchema            |
      | 1                                   | generateAlphaNumericRandomString(5) | generateAlphaNumericRandomString(5) | 201    | testData.expectedResponse |
      | 2                                   | null                                | ""                                  | 201    | testData.expectedResponse |
      | 3                                   | generateRandomNumber(5)             | generateRandomNumber(5)             | 201    | testData.expectedResponse |
      | generateRandomNumber(5)             | generateAlphaNumericRandomString(5) | generateAlphaNumericRandomString(5) | 201    | testData.expectedResponse |
      | generateRandomNumber(5)             | ""                                  | null                                | 201    | testData.expectedResponse |
      | generateRandomNumber(5)             | generateRandomNumber(5)             | generateRandomNumber(5)             | 201    | testData.expectedResponse |
      | generateAlphaNumericRandomString(5) | generateAlphaNumericRandomString(5) | generateAlphaNumericRandomString(5) | 201    | testData.expectedResponse |
      | generateAlphaNumericRandomString(5) | null                                | null                                | 201    | testData.expectedResponse |
      | generateAlphaNumericRandomString(5) | generateRandomNumber(5)             | generateRandomNumber(5)             | 201    | testData.expectedResponse |
      | ""                                  | generateAlphaNumericRandomString(5) | generateAlphaNumericRandomString(5) | 201    | testData.expectedResponse |
      | null                                | generateAlphaNumericRandomString(5) | generateAlphaNumericRandomString(5) | 201    | testData.expectedResponse |

  @updatePosts
  Scenario Outline: Update posts with different data
    * def expectedBody = <body>
    And def updateResponse = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_updateTitle',{"title": <newTitle>,"body": expectedBody,"userId": <userId>}).response
    * match updateResponse == <expectedSchema>
    * match updateResponse.title == <newTitle>
    * match updateResponse.body == expectedBody
    * match updateResponse.userId == <userId>

    Examples:
      | userId                              | newTitle                            | body                                | status | expectedSchema            |
      | 1                                   | generateAlphaNumericRandomString(5) | generateAlphaNumericRandomString(5) | 200    | testData.expectedResponse |
      | 2                                   | null                                | ""                                  | 200    | testData.expectedResponse |
      | 3                                   | generateRandomNumber(5)             | generateRandomNumber(5)             | 201    | testData.expectedResponse |
      | generateRandomNumber(5)             | generateAlphaNumericRandomString(5) | generateAlphaNumericRandomString(5) | 201    | testData.expectedResponse |
      | generateRandomNumber(5)             | ""                                  | null                                | 201    | testData.expectedResponse |
      | generateRandomNumber(5)             | generateRandomNumber(5)             | generateRandomNumber(5)             | 201    | testData.expectedResponse |
      | generateAlphaNumericRandomString(5) | generateAlphaNumericRandomString(5) | generateAlphaNumericRandomString(5) | 201    | testData.expectedResponse |
      | generateAlphaNumericRandomString(5) | null                                | null                                | 201    | testData.expectedResponse |
      | generateAlphaNumericRandomString(5) | generateRandomNumber(5)             | generateRandomNumber(5)             | 201    | testData.expectedResponse |
      | ""                                  | generateAlphaNumericRandomString(5) | generateAlphaNumericRandomString(5) | 201    | testData.expectedResponse |
      | null                                | generateAlphaNumericRandomString(5) | generateAlphaNumericRandomString(5) | 201    | testData.expectedResponse |

