@prod @jsonPlaceholder
Feature: Fetch Posts and Albums

  Scenario: Get posts for id 1
    Given def allPosts = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getAllPosts',{ expectedStatus: 200 }).response
    Then def postById1 = get allPosts[?(@.id==1)]
    Then karate.log("posts by id:1 ",postById1)
    Then match each postById1 == {userId: '#number', id:1, title:'#string', body:'#string'}

  Scenario: Get albums for id 1
    Given def allPosts = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getAllAlbums',{ expectedStatus: 200 }).response
    Then def albumsById1 = get allPosts[?(@.id==1)]
    Then karate.log("albums by id:1 ",albumsById1)
    Then match each albumsById1 == {userId: '#number', id:1, title:'#string'}
