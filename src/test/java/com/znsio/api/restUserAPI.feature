@userPost @prod
#  TARGET_ENVIRONMENT=prod TYPE=api TAG=@userPost ./gradlew test
Feature: Fetch posts and comments
  Background:
    * def jsonData = read('classpath:com/znsio/templates/JSONPlaceHolderData.json')

  @getPosts
  Scenario Outline: Get posts for specific User id
    Given def getPosts = karate.call('classpath:com/znsio/templates/restUserTemplates.feature@t_getUserPosts', {'user_Id': <userId>})
    Then karate.log("Response from get request for posts with userId <userId>: ", getPosts.response)
    And match each getPosts.response[*].userId == userId
    And match each getPosts.response[*] == jsonData.postSchema
    Examples:
      | userId |
      |    1   |
      |   -1   |
      |  'xyz' |
      | '1#a'  |
      | '@!*'  |
      |        |

  @getComments
  Scenario Outline: Get albums for specific User id
    Given def getAlbums = karate.call('classpath:com/znsio/templates/restUserTemplates.feature@t_getUserAlbums', {'user_Id': <userId>})
    Then karate.log("Response from get request for albums with userId <userId>: ", getAlbums.response)
    And match each getAlbums.response[*].userId == userId
    And match each getAlbums.response[*] == jsonData.albumSchema
    Examples:
      | userId |
      |    1   |
      |   -1   |
      |  'xyz' |
      | '1#a'  |
      | '@!*'  |
      |        |
