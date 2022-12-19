@prod @postAlbumAPI

  # TARGET_ENVIRONMENT=prod TYPE=workflow TAG=@postAlbumAPI ./gradlew test
Feature: Posts, Comment, Album API

  Background:
    * def getPostData = read('classpath:com/znsio/templates/postsAPI.json')
    * def getAlbumData = read('classpath:com/znsio/templates/albumAPI.json')

  @getPosts
  Scenario Outline: Get all posts with different userId
    * karate.log('userId :' ,<userId>)
    Given def fetchPostsData = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getPostsById',{"userId": <userId> ,"status": <status>})
    * match fetchPostsData.response == <expectedSchema>

    Examples:
      | userId                              | status | expectedSchema            |
      | 1                                   | 200    | getPostData.expectedResponse |
      | 2                                   | 200    | getPostData.expectedResponse |
      | 3                                   | 200    | getPostData.expectedResponse |
      | generateRandomNumber(5)             | 404    | getPostData.negativeResponse |
      | generateAlphaNumericRandomString(5) | 404    | getPostData.negativeResponse |
      | ""                                  | 200    | getPostData.expectedResponse |
      | null                                | 404    | getPostData.negativeResponse |

  @getAlbums
  Scenario Outline: Get all albums with different userId
    * karate.log('userId :' ,<userId>)
    Given def fetchAlbumData = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getAlbumsById',{"userId": <userId> ,"status": <status>})
    * match fetchAlbumData.response == <expectedSchema>

    Examples:
      | userId                              | status | expectedSchema            |
      | 1                                   | 200    | getAlbumData.expectedResponse |
      | 2                                   | 200    | getAlbumData.expectedResponse |
      | 3                                   | 200    | getAlbumData.expectedResponse |
      | generateRandomNumber(5)             | 400    | getAlbumData.negativeResponse |
      | generateAlphaNumericRandomString(5) | 400    | getAlbumData.negativeResponse |
      | ""                                  | 200    | getAlbumData.expectedResponse |
      | null                                | 200    | getAlbumData.expectedResponse |

