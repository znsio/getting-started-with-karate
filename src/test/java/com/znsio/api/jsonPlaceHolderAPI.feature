@jsonplaceholder @prod
Feature: JsonPlaceHolder API

  @posts
  Scenario: Get all the posts with specific userId
    * def featureDataResponse = karate.call('classpath:com/znsio/templates/placeHolderTemplates.feature@t_getPostByUserId', {expectedStatus: 200})
    * karate.log('response : ',featureDataResponse.response)
    * karate.log('status : ',featureDataResponse.responseStatus)
    * match featureDataResponse.response == featureDataResponse.testData.positiveResponse.expectedPost

  @comments
  Scenario: Get all the comments with specific userId
    * karate.log('Find the number of comments')
    * def featureData = karate.call('classpath:com/znsio/templates/placeHolderTemplates.feature@t_getCommentsByUserId', {expectedStatus: 200})
    * karate.log('allComments : ', featureData)
    * def actualLength = featureData.response.length
    * karate.log('actualLength : ', actualLength)
    * def expLength = featureData.testData.positiveResponse.expectedComment.length
    * karate.log('expectedLength : ', expLength)
    * match actualLength == expLength
    * match featureData.response contains featureData.testData.positiveResponse.expectedComment.data

#    Assignment2
  @posts
  Scenario Outline: Get all the posts with different userIds
    * karate.log('userId : ', <userId>)
    * def templateCallResponse = karate.call('classpath:com/znsio/templates/placeHolderTemplates.feature@t_getPostByUserId', {userId: <userId>, expectedStatus: <status>})
    * karate.log('response : ', templateCallResponse.response)
    * karate.log('status : ', templateCallResponse.responseStatus)
    * def positiveExpResponseSchema = templateCallResponse.testData.positiveResponse.expectedPost
    * def negativeExpResponseSchema = templateCallResponse.testData.negativeResponse.expectedPost
    * match templateCallResponse.response == <expectedSchema>

    Examples:
      | userId                              | status | expectedSchema            |
      | 1                                   | 200    | positiveExpResponseSchema |
      | 2                                   | 200    | positiveExpResponseSchema |
      | 3                                   | 200    | positiveExpResponseSchema |
      | generateRandomNumber(5)             | 404    | negativeExpResponseSchema |
      | generateAlphaNumericRandomString(3) | 404    | negativeExpResponseSchema |

  @comments
  Scenario Outline: Get all the comments with specific userId
    * karate.log('UserId : ', <userId>)
    * karate.log('Find the number of comments')
    * def templateCallResponse = karate.call('classpath:com/znsio/templates/placeHolderTemplates.feature@t_getCommentsByUserId', {userId: <userId>, expectedStatus: <status>})
    * karate.log('response : ', templateCallResponse.response)
    * karate.log('status : ', templateCallResponse.responseStatus)
    * def actualLength = templateCallResponse.response.length
    * karate.log('actualLength : ', actualLength)
    * def positiveExpResponseSchema = templateCallResponse.testData.positiveResponse.expectedComment.data
    * def negativeExpResponseSchema = templateCallResponse.testData.negativeResponse.expectedComment
    * match templateCallResponse.response contains <expectedSchema>

    Examples:
      | userId                              | status | expectedSchema            |
      | 1                                   | 200    | positiveExpResponseSchema |
      | 2                                   | 200    | positiveExpResponseSchema |
      | 3                                   | 200    | positiveExpResponseSchema |
      | generateRandomNumber(5)             | 200    | negativeExpResponseSchema |
      | generateAlphaNumericRandomString(3) | 200    | negativeExpResponseSchema |


  @createPost
  Scenario Outline: Create posts with different data
    * def requestBody =
    """
    {
      "userId": <userId>,
      "title": <title>,
      "body": <text>
    }
    """

    * def response = karate.call('classpath:com/znsio/templates/placeHolderTemplates.feature@t_createPost', {requestData: requestBody, expectedStatus: <status>}).response
    * karate.log('Response :: ', response)
    * match requestBody.userId == response.userId
    * match requestBody.title == response.title
    * match requestBody.body == response.body
    * match requestBody.userId == response.userId
    * match response.id == '#number'


    Examples:
      | userId                     | title                                   | text                                    | status |
      | #(generateRandomNumber(5)) | #(generateAlphaNumericRandomString(10)) | #(generateAlphaNumericRandomString(30)) | 201    |
      | #(generateRandomNumber(7)) | #(generateAlphaNumericRandomString(10)) | null                                    | 201    |
      | #(generateRandomNumber(5)) | null                                    | #(generateAlphaNumericRandomString(30)) | 201    |
      | null                       | #(generateAlphaNumericRandomString(10)) | #(generateAlphaNumericRandomString(30)) | 201    |
      | null                       | null                                    | null                                    | 201    |


  @updatePost
  Scenario Outline: Update posts with varied data
    * karate.log('Step: 1 :: Create a post')
    * def id = karate.call('classpath:com/znsio/templates/placeHolderTemplates.feature@t_createPost', {expectedStatus: 201}).response.id
    * karate.log("id: ", id)

    * def requestData =
    """
    {
      "userId": <userId>,
      "title": <title>,
      "body": <text>
    }
    """

    * karate.log('Step: 2 :: update the post with userId :', id)
    * def response = karate.call('classpath:com/znsio/templates/placeHolderTemplates.feature@t_updatePost', {id: id, requestData: requestData, expectedStatus: <updateStatus>}).response
    * karate.log('UpdatePost response :: ', response)
    * karate.log('Validating update post response with expected Response')
    * match requestData.userId == response.userId
    * match requestData.title == response.title
    * match requestData.body == response.body
    * match response.id == id

    Examples:

      | userId                     | title                                   | text                                    | updateStatus |
      | #(generateRandomNumber(5)) | #(generateAlphaNumericRandomString(10)) | #(generateAlphaNumericRandomString(25)) | 200          |
      | #(generateRandomNumber(7)) | #(generateAlphaNumericRandomString(13)) | null                                    | 200          |
      | #(generateRandomNumber(5)) | null                                    | #(generateAlphaNumericRandomString(30)) | 200          |
      | null                       | #(generateAlphaNumericRandomString(15)) | #(generateAlphaNumericRandomString(35)) | 200          |
      | null                       | null                                    | null                                    | 200          |