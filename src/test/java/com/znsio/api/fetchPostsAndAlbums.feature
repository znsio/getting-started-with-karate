@UserPosts @prod
Feature: Fetch User Posts and Comments
  Background:
    * def userId = 1
    * def testData = read('classpath:com/znsio/templates/userData.json')
  @getPosts
  Scenario: Get posts with specific User id
    * def fetchPosts = karate.call('classpath:com/znsio/templates/fetchPostAndComment.feature@t_getPost', {"userId": userId, expectedStatus: 200})
    * karate.log('response : ',fetchPosts.response)
    * match each fetchPosts.response[*].userId == userId
    * match each fetchPosts.response[*] == testData.expectedPostsResponse

  @getComments
  Scenario: Get comment with specific User id
    * def fetchComments = karate.call('classpath:com/znsio/templates/fetchPostAndComment.feature@t_getComments', {"userId": userId})
    * karate.log('response : ',fetchComments.response)
    * print fetchComments.response
    * match each fetchComments.response == testData.expectedCommentResponse

  @getPostsWithInvalidUserId
  Scenario: Get posts with user id that doesn't exist
    * def fetchPosts = karate.call('classpath:com/znsio/templates/fetchPostAndComment.feature@t_getPost', {"userId": 100, expectedStatus: 200})
    * karate.log('response : ',fetchPosts.response)
    * assert fetchPosts.response.arr == null

  @getComments1
  Scenario: Get comment with specific User id
    * def fetchAlbums = karate.call('classpath:com/znsio/templates/fetchPostAndComment.feature@t_getAlbums', {"userId": userId, expectedStatus: 200})
    * karate.log('response : ',fetchAlbums.response)
    * match each fetchAlbums.response[*].userId == userId
    * match each fetchAlbums.response == testData.expectedAlbumResponse

  @getComments2
  Scenario: Get comment with User id that doesn't exist
    * def fetchAlbums = karate.call('classpath:com/znsio/templates/fetchPostAndComment.feature@t_getAlbums', {"userId": 100, expectedStatus: 200})
    * karate.log('response : ',fetchAlbums.response)
    * assert fetchAlbums.response.arr == null
