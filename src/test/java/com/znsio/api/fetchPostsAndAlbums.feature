@prod @FetchUserPostsAndAlbums
Feature: Fetch user posts and comments

  Background: passing id
    * def userId = 1

  @posts
  Scenario: Get all posts with specific userId
    Given def userPosts = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getPostsById',{"userId": userId})
    And karate.log(userPosts.response)
    Then match userPosts.response.id == userId
    And match userPosts.response.userId == '#number'


  @comments
  Scenario: Get all comments with specific userId
    Given def userComments = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getCommentsById',{"userId": userId})
    And karate.log(userComments.response)
    Then match each userComments.response[*].postId == userId

  @albums
  Scenario: Get all albums details
    Given def userAlbums = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getAlbums')
    * def totalAlbums = userAlbums.response.length
    Then match totalAlbums == 100


