@userPost @prod
#  TARGET_ENVIRONMENT=prod TYPE=api TAG=@userPost ./gradlew test
Feature: Fetch posts and comments
  Background:
    * def userId = 1
    * def userIdInvalid = "a#1"
    * def jsonData = read('classpath:com/znsio/templates/JSONPlaceHolderData.json')

  @getPosts
  Scenario: Get posts for specific User id
    Given def getPosts = karate.call('classpath:com/znsio/templates/restUserTemplates.feature@t_getUserPosts', {'user_Id': userId})
    Then karate.log("Response from get request for posts with valid userId: ", getPosts.response)
    And match each getPosts.response[*].userId == userId
    And match each getPosts.response[*] == jsonData.postSchema

  @getPosts
  Scenario: Get posts for invalid User id
    Given def getPosts = karate.call('classpath:com/znsio/templates/restUserTemplates.feature@t_getUserPosts', {'user_Id': userIdInvalid})
    Then karate.log("Response from get request for posts with invalid userId: ", getPosts.response)
    And assert getPosts.response.length == 0

  @getComments
  Scenario: Get albums for specific User id
    Given def getAlbums = karate.call('classpath:com/znsio/templates/restUserTemplates.feature@t_getUserAlbums', {'user_Id': userId})
    Then karate.log("Response from get request for albums with valid userId: ", getAlbums.response)
    And match each getAlbums.response[*].userId == userId
    And match each getAlbums.response[*] == jsonData.albumSchema

  @getComments
  Scenario: Get albums for invalid User id
    Given def getAlbums = karate.call('classpath:com/znsio/templates/restUserTemplates.feature@t_getUserAlbums', {'user_Id': userIdInvalid})
    Then karate.log("Response from get request for albums with invalid userId: ", getAlbums.response)
    And assert getAlbums.response.length == 0
