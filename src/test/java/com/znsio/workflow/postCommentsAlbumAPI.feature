@prod @postCommentAlbumAPI

  # TARGET_ENVIRONMENT=prod TYPE=workflow TAG=@postCommentAlbumAPI ./gradlew test
Feature: Posts, Comment, Album API

  Background:
    * def testData = read('classpath:com/znsio/templates/userData.json')

  @getPosts
  Scenario Outline: Get all posts with different userId
    * karate.log('userId :' ,<userId>)
    Given def fetchPostsData = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getPostsById',{"userId": <userId> ,"status": <status>})
    * match fetchPostsData.response == <expectedSchema>

    Examples:
      | userId                              | status | expectedSchema            |
      | 1                                   | 200    | testData.expectedResponse |
      | 2                                   | 200    | testData.expectedResponse |
      | 3                                   | 200    | testData.expectedResponse |
      | generateRandomNumber(5)             | 404    | testData.negativeResponse |
      | generateAlphaNumericRandomString(5) | 404    | testData.negativeResponse |
      | ""                                  | 200    | testData.expectedResponse |
      | null                                | 404    | testData.negativeResponse |

  @getAlbums
  Scenario Outline: Get all albums with different userId
    * karate.log('userId :' ,<userId>)
    Given def fetchAlbumData = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getAlbumsById',{"userId": <userId> ,"status": <status>})
    * match fetchAlbumData.response == <expectedSchema>

    Examples:
      | userId                              | status | expectedSchema            |
      | 1                                   | 200    | testData.expectedResponse |
      | 2                                   | 200    | testData.expectedResponse |
      | 3                                   | 200    | testData.expectedResponse |
      | generateRandomNumber(5)             | 400    | testData.negativeResponse |
      | generateAlphaNumericRandomString(5) | 400    | testData.negativeResponse |
      | ""                                  | 200    | testData.expectedResponse |
      | null                                | 200    | testData.expectedResponse |

