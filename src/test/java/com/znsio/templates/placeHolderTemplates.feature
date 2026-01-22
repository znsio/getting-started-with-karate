@template
Feature: Templates for jsonPlaceHolder

  Background:
    * url env.jsonPlaceHolderUrl
    * def testData = read('classpath:' + karate.info.featureDir.split('test/')[1] + '/templateData/' + karate.info.featureFileName.split('.')[0] + '_testData.json')
    * def userId = typeof userId === 'undefined' ? 1 : userId
    * def requestData = typeof requestData === 'undefined' ? testData.createPost : requestData


  @t_getPostByUserId
  Scenario: Get all the posts with specific userId
    * print "userId", userId
    * path 'posts/' + userId
    * print "Get all posts with userId as " + userId
    * method GET
    * print "Posts found: ", response
    * print "Status: ", responseStatus
    * match responseStatus == expectedStatus

  @t_getCommentsByUserId
  Scenario: Get all the comments with specific userId
    Given path 'comments'
    And param id = userId
    When method GET
    * print "Number of comments found: ", response.length
    * print "comments found: ", response
    * match responseStatus == expectedStatus


  @t_createPost
  Scenario: Create post with specific userId
    * path 'posts'
    * request requestData
    * karate.log('requestBody: ',requestData)
    * method POST
    * karate.log('responseStatus: ',expectedStatus)
    * match responseStatus == expectedStatus
    * print "New post created with Id: " + response.id
    * print "Response", response

  @t_updatePost
  Scenario: Update post by userId
    * path 'posts/',id
    * request requestData
    * method PUT
    * karate.log('responseStatus: ',expectedStatus)
    * match responseStatus == expectedStatus
    * print "Response for postUpdate", response
