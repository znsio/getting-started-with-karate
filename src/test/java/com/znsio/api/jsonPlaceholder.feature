@eat @assignment
Feature: API tests for https://jsonplaceholder.typicode.com/

  Scenario: Get list of Posts
    Given def listOfPosts = karate.call('classpath:com/znsio/templates/jsonPlaceholderTemplates.feature@t_getPosts').response
    Then print "listOfPosts: " + listOfPosts.length
    And print "This is my list of posts-------------> " + listOfPosts
    And print listOfPosts.length

  Scenario: Get list of Albums
    Given def listOfAlbums = karate.call('classpath:com/znsio/templates/jsonPlaceholderTemplates.feature@t_getAlbums').response
    Then print "listOfAlbums: " + listOfAlbums.length
    And print "This is my list of albums-------------> " + listOfAlbums
    And print listOfAlbums.length