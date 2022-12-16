@prod
Feature: Create and Update User Posts

  Background:
    * def userId = generateRandomNumber(3)
    * def title = generateAlphaNumericRandomString(5)
    * def body = generateAlphaNumericRandomString(10)
    * def testData = read('classpath:com/znsio/templates/userData.json')

  @createPost
  Scenario: Create a User post and then Update its title
    * def createPost = karate.call('classpath:com/znsio/templates/fetchPostAndAlbums.feature@t_createPost', {"userId": userId, "title": title, "body": body, expectedStatus: 201})
    * karate.log('response : ',createPost.response)
    * match createPost.response == testData.expectedCreatePostsResponse
    * def id = createPost.response.userId
    * def fetchPosts = karate.call('classpath:com/znsio/templates/fetchPostAndAlbums.feature@t_getPost', {"userId": id, expectedStatus: 200})
    * match fetchPosts.response.userId == userId
    * match fetchPosts.response.title == title
    * match fetchPosts.response.body == body
    * def newTitle = generateAlphaNumericRandomString(5)
    * def updatePost = karate.call('classpath:com/znsio/templates/fetchPostAndAlbums.feature@t_updatePost', {"title": newTitle, expectedStatus: 201})
    * karate.log('response : ',updatePost.response)
    * match updatePost.response.title == newTitle
    * def fetchPosts = karate.call('classpath:com/znsio/templates/fetchPostAndAlbums.feature@t_getPost', {"userId": id, expectedStatus: 200})
    * match fetchPosts.response.title == newTitle