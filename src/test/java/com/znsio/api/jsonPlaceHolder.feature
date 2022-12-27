@prod @jsonPlaceholder
Feature: Fetch Posts and Albums

  Scenario: Get posts with id 1
    Given def postsWithId1 = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getAllPosts',{ id: 1, expectedStatus: 200 }).response
    Then karate.log("posts with id:1 ",postsWithId1)
    Then match postsWithId1 == {userId: '#number', id:1, title:'#string', body:'#string'}

  Scenario: Get albums with id 1
    Given def albumsWithId1 = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getAllAlbums',{ id: 1, expectedStatus: 200 }).response
    Then karate.log("albums with id:1 ",albumsWithId1)
    Then match albumsWithId1 == {userId: '#number', id:1, title:'#string'}
