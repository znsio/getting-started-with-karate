@prod @postsAndAlbums
Feature: Getting all the posts and albums with UserID specification

  Background:
    * def userIdOneQuery = {userId:'1'}

  @posts
  Scenario: Get all the posts with UserID one

    Given  def postsUserIdOneResult = call read('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getPosts'){query: userIdOneQuery,ecpectedStatus: 200}
    And karate.log('postsWithUserId_one---',postsUserIdOneResult)
    Then match postsUserIdOneResult.response[*].userId contains [1]
    And match postsUserIdOneResult.response[*] contains {"userId":'#number',"id":'#number',"title":'#string',"body":'#string'}


  @albums
  Scenario: Get all the albums with UserID one

    Given def albumsUserIdOneResult = call read('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getAlbums') {query: userIdOneQuery,ecpectedStatus: 200}
    And karate.log('albumsWithUserId_one----',albumsUserIdOneResult)
    Then match albumsUserIdOneResult.response[*].userId contains [1]
    And match albumsUserIdOneResult.response[*] contains {"userId":'#number',"id":'#number',"title":'#string'}




