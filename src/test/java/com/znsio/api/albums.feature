@prod @albums
Feature: API test for https://jsonplaceholder.typicode.com

  Scenario: Get albums of user
    Given def userId = 1
    And def checkUserIdInAlbums = karate.call('classpath:com/znsio/templates/albumsTemplates.feature@getAlbumsOfUser', {'userId' : userId}).checkUserIdInAlbums
    Then assert checkUserIdInAlbums == true
