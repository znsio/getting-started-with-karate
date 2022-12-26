@prod @jsonPlaceholder
Feature: API tests for JsonPlaceholder

  Scenario: Get posts for id 1
    Given def allPosts = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getAllPosts').response
    Then def postById1 = get allPosts[?(@.id==1)]
    Then print "postById1: ",postById1
    Then match each postById1 == {userId: '#number', id:1, title:'#string', body:'#string'}

  Scenario: Get albums for id 1
    Given def allPosts = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getAllAlbums').response
    Then def albumsById1 = get allPosts[?(@.id==1)]
    Then print "albumsById1: ",albumsById1
    Then match each albumsById1 == {userId: '#number', id:1, title:'#string'}