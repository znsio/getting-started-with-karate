@template
Feature: Templates for jsonPlaceHolder

  Background:
    * url env.jsonPlaceHolderUrl
    * def testData = read('classpath:' + karate.info.featureDir.split('test/')[1] + '/templateData/' + karate.info.featureFileName.split('.')[0] + '_testData.json')
    * def userId = typeof userId === 'undefined' ? 1 : userId
    * def getRequestData =
    """
    function(testCaseType){

       switch(testCaseType) {

        case "updateAllKeysWithValidValues":
        case "createPostWithAllValidValues":
          return updateRequestData(testData.createPost.positive_TC1);

        case "createPostWithTitleAsNull":
          return testData.createPost.negative_TC1;

        case "createPostWithTitleAsNull":
          return updateRequestData(testData.createPost.positive_TC3);

        case "createPostWithBodyAsNull":
          return updateRequestData(testData.createPost.positive_TC4);

        case "createPostWithIdAsNull":
          return updateRequestData(testData.createPost.positive_TC5);
        case "updateAllKeysAsNull":
          return {}
        case "updateBodyWithValidValue":
          return {body: generateAlphaNumericRandomString(5)}
        case "updateTitleWithValidValue":
          return {title: generateAlphaNumericRandomString(10)}
        case "updateUserIdWithValidValue":
          return {userId: generateAlphaNumericRandomString(2)}
        }
    }
    """
    * def updateRequestData =
    """
    function(requestData){
      if(requestData.userId == "")
        requestData.userId = generateAlphaNumericRandomString(3);

      if(requestData.title == "")
        requestData.title = generateAlphaNumericRandomString(10);

      if(requestData.title == "")
        requestData.body = generateAlphaNumericRandomString(30);

      if(requestData.id == "")
        requestData.id = generateAlphaNumericRandomString(3);
      return requestData;
    }
    """

    * def getExpectedResponse =
    """
       function(requestData){
        if(requestData == null){
          return {'id': '#number'}
        }
        else
          requestData.id = '#number'

        return requestData
       }

    """

  @t_getPostByUserId
  Scenario: Get all the posts with specific userId
    * print "userId", userId
    * path 'posts/' + userId
    * print "Get all posts with userId as " + userId
    * method GET
    * print "Posts found: ", response

  @t_getCommentsByUserId
  Scenario: Get all the comments with specific userId
    Given path 'comments'
    And param id = userId
    When method GET
    * print "Number of comments found: ", response.length
    * print "comments found: ", response

  @t_createPost
  Scenario: Create post with specific userId
    Given path 'posts'
    And def requestData = getRequestData(testCaseType)
    And request requestData
    When method POST
    * print "New post created with Id: " + response.id
    * print "Response", response
    * def expectedResponse = getExpectedResponse(requestData)

  @t_updatePost
  Scenario: Update post by userId
    * path 'posts/' + id
    * def requestData = getRequestData(testCaseType)
    * requestData.id = id
    * request requestData
    * method PUT
    * print "Response for post update", response
    * def expectedResponse = getExpectedResponse(requestData)
