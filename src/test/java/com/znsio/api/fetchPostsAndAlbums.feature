@prod @FetchUserPostsAndAlbums

# TARGET_ENVIRONMENT=prod TYPE=api TAG=@FetchUserPostsAndAlbums ./gradlew test
Feature: Fetch user posts and comments

  Background: passing id
    * def userId = 1

  @posts
  Scenario: Get all posts with specific userId
    Given def userPosts = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getPostsById',{"userId": userId})
    Then match userPosts.response.id == userId
    And match userPosts.response.userId == '#number'

  @albums
  Scenario: Get all albums with specific userId
    Given def userAlbums = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getAlbumsById').response
    Then match each userAlbums[*].userId == userId



