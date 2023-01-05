@prod @postsAndAlbums
Feature: Getting all the posts and albums with UserID specification

  @posts_UserIdOne
  Scenario: Get all the posts with UserID one
    Given  def postsUserIdOneResult = call read('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getPosts'){userId: 1,expectedStatus: 200}
    And karate.log('postsWithUserId_one---',postsUserIdOneResult.response)
    Then match each postsUserIdOneResult.response contains {userId: 1}
    And match each postsUserIdOneResult.response[*] contains {"userId":'#number',"id":'#number',"title":'#string',"body":'#string'}


  @albums_UserIdOne
  Scenario: Get all the albums with UserID one
    Given def albumsUserIdOneResult = call read('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getAlbums') {userId: 1,expectedStatus: 200}
    And karate.log('albumsWithUserId_one----',albumsUserIdOneResult.response)
    Then match each albumsUserIdOneResult.response contains {userId: 1}
    And match each albumsUserIdOneResult.response[*] contains {"userId":'#number',"id":'#number',"title":'#string'}


