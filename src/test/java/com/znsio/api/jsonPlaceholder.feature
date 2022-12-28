@eat
Feature: Fetch posts and albums of a user

  @jsonPlaceholder
  Scenario: Get list of Posts
    Given def listOfPosts = call read('classpath:com/znsio/templates/jsonPlaceholderTemplates.feature@t_getUserPosts') {userId: 1}
    Then  karate.log("listOfPosts: " + listOfPosts.data.length)
    And karate.log("This is my list of posts-------------> ", listOfPosts.data)
    And match listOfPosts.data[*].userId contains [1]
  @jsonPlaceholder
  Scenario: Get list of Albums
    Given def listOfAlbums = call read('classpath:com/znsio/templates/jsonPlaceholderTemplates.feature@t_getUserAlbums') {userId: 1}
    Then karate.log("listOfAlbums: " + listOfAlbums.data.length)
    And karate.log("This is my list of albums-------------> ", listOfAlbums.data)
    And match listOfAlbums.data[*].userId contains [1]