@assignment @prod
Feature: fetch posts and albums

  Scenario: Fetch all the posts for a user with id 1

    Given def listOfPosts = call read('classpath:com/znsio/templates/typicodeTemplates.feature@t_getUserDetails') {userId: 1, dataType: posts}
    * print listOfPosts.data
    * def func =
    """
      function(data, id){
        for(let i=0;i<data.length;i++){
          if(data[i].userId != id){
            return false;
          }
        }
        return true;
      }
    """
    * def result = call func listOfPosts.data, 1
    Then match result == true

  Scenario: Fetch all the albums for a user with id 1

    Given def listOfAlbums = call read('classpath:com/znsio/templates/typicodeTemplates.feature@t_getUserDetails') {userId: 1, dataType: albums}
    * print "Albums : " + karate.pretty(listOfAlbums.data)
    Then match each listOfAlbums.data contains {userId: 1}