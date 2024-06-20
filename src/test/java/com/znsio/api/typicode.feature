@jsonPlaceholder @prod
Feature: Fetch posts and albums

  Scenario: Fetch posts for a user

    Given def listOfPosts = call read('classpath:com/znsio/templates/typicodeTemplates.feature@t_getUserPosts') {userId: 1, status_code: 200}
    * karate.log("User posts with id 1 : " , listOfPosts.posts)
    Then match each listOfPosts.posts contains {id: '#number', userId: '#number', title: '#string'}
    And match each listOfPosts.posts contains {userId: 1}

  Scenario: Fetch albums for a user

    Given def listOfAlbums = call read('classpath:com/znsio/templates/typicodeTemplates.feature@t_getUserAlbums') {userId: 1, status_code: 200}
    * karate.log("User albums with id 1 : " , listOfAlbums.albums))
    Then match each listOfAlbums.albums contains {id: '#number', userId: '#number', title: '#string'}
    And match each listOfAlbums.albums contains {userId: 1}