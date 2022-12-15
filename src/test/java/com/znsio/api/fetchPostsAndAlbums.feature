@UserPosts @prod
Feature: Fetch User Posts and Albums

  Background:
    * def userId = 1
    * def testData = read('classpath:com/znsio/templates/userData.json')

  @getPosts
  Scenario: Get posts with specific User id
    * def fetchPosts = karate.call('classpath:com/znsio/templates/fetchPostAndAlbums.feature@t_getPost', {"userId": userId, expectedStatus: 200})
    * karate.log('response : ',fetchPosts.response)
    * match each fetchPosts.response[*].userId == userId
    * match fetchPosts.response.userId == '#number'
    * match fetchPosts.response.id == '#number'
    * match fetchPosts.response.title == '#string'
    * match fetchPosts.response.body == '#string'


  @getPosts
  Scenario: Get posts with user id that doesn't exist
    * def fetchPosts = karate.call('classpath:com/znsio/templates/fetchPostAndAlbums.feature@t_getPost', {"userId": 100, expectedStatus: 200})
    * karate.log('response : ',fetchPosts.response)
    * assert fetchPosts.response.arr == null

  @getComments
  Scenario: Get albums with specific User id
    * def fetchAlbums = karate.call('classpath:com/znsio/templates/fetchPostAndAlbums.feature@t_getAlbums', {"userId": userId, expectedStatus: 200})
    * karate.log('response : ',fetchAlbums.response)
    * match each fetchAlbums.response[*].userId == userId
    * match each fetchAlbums.response == testData.expectedAlbumResponse

  @getComments
  Scenario: Get albums with User id that doesn't exist
    * def fetchAlbums = karate.call('classpath:com/znsio/templates/fetchPostAndAlbums.feature@t_getAlbums', {"userId": 100, expectedStatus: 200})
    * karate.log('response : ',fetchAlbums.response)
    * assert fetchAlbums.response.arr == null
