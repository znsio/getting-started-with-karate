@template
Feature: API test for https://jsonplaceholder.typicode.com

  Background:
    Given url env.jsonPlaceHolderUrl
    And print "JSONPlaceHolderURL : " + env.jsonPlaceHolderUrl


  @getAlbumsOfUser
  Scenario: Get albums of a user
    Given def path = "/albums"
    And print "Get albums of user from URl " + env.jsonPlaceHolderUrl + path
    And path path
    And param userId = userId
    When method GET
    Then status 200
    And def albumsOfUser = response
    And print "Albums of user with ID " + userId + " : " , albumsOfUser
    And def fun =
      """
      function(responseArray){
      for (let i = 0; i < responseArray.length; i++){
          if(responseArray[i].userId != userId) return false
          else return true
      }
      }
      """
    And def checkUserIdInAlbums = fun(albumsOfUser)
