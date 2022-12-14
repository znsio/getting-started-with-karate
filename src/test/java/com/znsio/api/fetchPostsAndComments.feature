@UserPosts @prod
Feature: Fetch User Posts and Comments
  Background:
    * def userId = 1
    * def testData = read('classpath:com/znsio/templates/userData.json')
  @getPosts
  Scenario: Get posts with specific User id
    * def getPostsResponse = karate.call('classpath:com/znsio/templates/fetchPostAndComment.feature@t_getPost', {"userId": userId})
    * print getPostsResponse.response
    * match getPostsResponse.response.id == userId
    * match getPostsResponse.response == testData.expectedPostsResponse

  @getComments
  Scenario: Get comment with specific User id
    * def getCommentsResponse = karate.call('classpath:com/znsio/templates/fetchPostAndComment.feature@t_getComments', {"userId": userId})
    * print getCommentsResponse.response
    * match getCommentsResponse.response contains testData.expectedCommentResponse
