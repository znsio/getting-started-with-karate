@prod @jsonPlaceholder
Feature: Fetch Posts and Albums

  Scenario: Get posts with id 1
    Given def postsWithUserIdOne = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getAllPosts',{ userId: 1, expectedStatus: 200 }).response
    Then karate.log("posts with userId:1 ",postsWithUserIdOne)
    Then match each postsWithUserIdOne..userId == 1
    Then match each postsWithUserIdOne == {userId:1 , id:'#number', title:'#string', body:'#string'}

  Scenario: Get albums with id 1
    Given def albumsWithIdOne = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getAllAlbums',{ userId: 1, expectedStatus: 200 }).response
    Then karate.log("albums with id:1 ",albumsWithIdOne)
    Then match each albumsWithIdOne..userId == 1
    Then match each albumsWithIdOne == {userId:1 , id:'#number', title:'#string'}
