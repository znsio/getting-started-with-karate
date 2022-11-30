@jsonplaceholder @prod
Feature: JsonPlaceHolder API

  @posts
  Scenario: Get all the posts with specific userId
    * print "userId : 1"
    * def featureData = karate.call('classpath:com/znsio/templates/placeHolderTemplates.feature@t_getPostByUserId')
    * print 'response : ', featureData.response
    * print 'status : ', featureData.responseStatus
    * match featureData.response == featureData.testData.positiveResponse.expectedPost
    * match featureData.responseStatus == featureData.testData.positiveResponse.status

  @comments
  Scenario: Get all the comments with specific userId
    * print "userId : 1"
    * print "Find the number of comments"
    * def featureData = karate.call('classpath:com/znsio/templates/placeHolderTemplates.feature@t_getCommentsByUserId')
    * print "allComments : ", featureData
    * def actualLength = featureData.response.length
    * print "actualLength : ", actualLength
    * print "expectedLength : ", featureData.testData.positiveResponse.expectedComment.length

    * match actualLength == featureData.testData.positiveResponse.expectedComment.length
    * match featureData.response contains featureData.testData.positiveResponse.expectedComment.data
    * match featureData.responseStatus == featureData.testData.positiveResponse.status

#    Assignment2
  @posts
  Scenario Outline: Get all the posts with different userIds
    * print "userId : " + <userId>
    * def templateCallResponse = karate.call('classpath:com/znsio/templates/placeHolderTemplates.feature@t_getPostByUserId', {userId: <userId>})
    * print 'response : ', templateCallResponse.response
    * print 'status : ', templateCallResponse.responseStatus
    * def getExpectedResponse =
    """
    function(status){

      if(status == 200){
        return templateCallResponse.testData.positiveResponse.expectedPost
      }
      return templateCallResponse.testData.negativeResponse.expectedPost
    }
    """
    * match templateCallResponse.response == getExpectedResponse(<status>)
    * match templateCallResponse.responseStatus == <status>

    Examples:
      | userId                              | status |
      | 1                                   | 200    |
      | 2                                   | 200    |
      | 3                                   | 200    |
      | generateRandomNumber(5)             | 404    |
      | generateAlphaNumericRandomString(3) | 404    |

  @comments
  Scenario Outline: Get all the comments with specific userId
    * print "userId : " + <userId>
    * print "Find the number of comments"
    * def templateCallResponse = karate.call('classpath:com/znsio/templates/placeHolderTemplates.feature@t_getCommentsByUserId', {userId: <userId>})
    * print 'response : ', templateCallResponse.response
    * print 'status : ', templateCallResponse.responseStatus
    * def actualLength = templateCallResponse.response.length
    * print "actualLength : ", actualLength
    * def getExpectedResponse =
    """
    function(userId){

      if(userId == 1 && userId == 2 && userId == 3){
        return templateCallResponse.testData.positiveResponse.expectedComment.data
      }
      return templateCallResponse.testData.negativeResponse.expectedComment
    }
    """
    * match templateCallResponse.response contains getExpectedResponse(<userId>)
    * match templateCallResponse.responseStatus == <status>

    Examples:
      | userId                              | status |
      | 1                                   | 200    |
      | 2                                   | 200    |
      | 3                                   | 200    |
      | generateRandomNumber(5)             | 200    |
      | generateAlphaNumericRandomString(3) | 200    |


  @createPost
  Scenario Outline: Create a post
    * def templateCallResponse = karate.call('classpath:com/znsio/templates/placeHolderTemplates.feature@t_createPost', {testCaseType: <testCaseType>})
    * print 'response : ', templateCallResponse.response
    * print 'status : ', templateCallResponse.responseStatus
    * match templateCallResponse.responseStatus == <status>
    * print 'Expected response::: ', templateCallResponse.expectedResponse
    * match templateCallResponse.response == templateCallResponse.expectedResponse

    Examples:
      | testCaseType                     | status |
      | "createPostWithAllValidValues"   | 201    |
      | "createPostWithAllFieldsAreNull" | 201    |
      | "createPostWithTitleAsNull"      | 201    |
      | "createPostWithBodyAsNull"       | 201    |
      | "createPostWithIdAsNull"         | 201    |


  @updatePost
  Scenario Outline: Update a post

    * def createPost =
    """
    function(postType){
      karate.log('Step: 1 :: Create a post');
      var createPostResponse = karate.call('classpath:com/znsio/templates/placeHolderTemplates.feature@t_createPost', {testCaseType: 'postType'});
      var id = createPostResponse.response.id;
      karate.log("id : ", id);
      karate.log('created post response : ', createPostResponse.response);
      karate.log('created post status : ', createPostResponse.responseStatus);
      karate.log('Validating create post response with expected Response');
      return createPostResponse
    }
    """

    * print 'Step: 1 :: Create a post'
    * def createPostResponse = createPost('<createPostType>')
    * match createPostResponse.responseStatus == <createStatus>;
    * match createPostResponse.response == createPostResponse.expectedResponse;
    * def id = createPostResponse.response.id

    * print 'Step: 2 :: update the post with userId :', id
    * def updatePostResponse = karate.call('classpath:com/znsio/templates/placeHolderTemplates.feature@t_updatePost', {id: id, testCaseType: <testCaseType>})
    * print 'update post response : ', updatePostResponse.response
    * print 'update post status : ', updatePostResponse.responseStatus
    * match updatePostResponse.responseStatus == <updateStatus>
    * print 'Validating update post response with expected Response'
    * match updatePostResponse.response == updatePostResponse.expectedResponse

    Examples:
      | testCaseType                   | updateStatus | createPostType               | createStatus |
      | "updateAllKeysWithValidValues" | 200          | createPostWithAllValidValues | 201          |
      | "updateAllKeysAsNull"          | 200          | createPostWithAllValidValues | 201          |
      | "updateBodyWithValidValue"     | 200          | createPostWithAllValidValues | 201          |
      | "updateTitleWithValidValue"    | 200          | createPostWithAllValidValues | 201          |
      | "updateUserIdWithValidValue"   | 200          | createPostWithAllValidValues | 201          |

