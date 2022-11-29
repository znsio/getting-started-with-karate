@jsonplaceholder @prod
Feature: JsonPlaceHolder API

  @posts
  Scenario: Get all the posts with specific userId
    * print "userId : 1" + jsonPlaceHolder.userId
    * def featureData = karate.call('classpath:com/znsio/templates/placeHolderTemplates.feature@t_getPostByUserId')
    * print 'response : ', featureData.response
    * print 'status : ', featureData.responseStatus
    * match featureData.response == featureData.testData.positiveResponse.expectedPost
    * match featureData.responseStatus == featureData.testData.positiveResponse.status

  @comments
  Scenario: Get all the comments with specific userId
    * print "userId : " + jsonPlaceHolder.userId
    * print "Find number of comments"
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
    * match templateCallResponse.responseStatus == <status>
    * match templateCallResponse.response contains getExpectedResponse(<userId>)
    * match templateCallResponse.responseStatus == <status>

    Examples:
      | userId                              | status |
      | 1                                   | 200    |
      | 2                                   | 200    |
      | 3                                   | 200    |
      | generateRandomNumber(5)             | 200    |
      | generateAlphaNumericRandomString(3) | 200    |