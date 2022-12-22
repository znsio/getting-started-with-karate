@assignment @prod
Feature: fetch posts and albums

  Scenario: Fetch all the posts for a user with id 1

    Given def listOfPosts = call read('classpath:com/znsio/templates/typicodeTemplates.feature@t_getUserDetails') {userId: 1, dataType: posts}
    Then print listOfPosts.data

  Scenario: Fetch all the albums for a user with id 1

    Given def listOfAlbums = call read('classpath:com/znsio/templates/typicodeTemplates.feature@t_getUserDetails') {userId: 1, dataType: albums}
    Then print listOfAlbums.data