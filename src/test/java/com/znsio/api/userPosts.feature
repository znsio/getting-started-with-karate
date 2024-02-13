@UserPosts @prod
Feature: Fetch, Create, Update user Posts and Albums

  @getPosts
  Scenario Outline: Get posts with specific User id
    * def testData = read('classpath:com/znsio/templates/fetchPostData.json')
    * def fetchPosts = karate.call('classpath:com/znsio/templates/fetchPostTemplate.feature@t_getPost', {"userId": <userId>, expectedStatus: <status>})
    * karate.log('response : ',fetchPosts.response)
    * match each fetchPosts.response == <expectedSchema>
    Examples:
      | userId                              | status | expectedSchema                 |
      | 1                                   | 200    | testData.expectedPostsResponse |
      | generateRandomNumber(4)             | 200    | testData.negativeResponse      |
      | generateAlphaNumericRandomString(7) | 200    | testData.negativeResponse      |
      | ""                                  | 200    | testData.negativeResponse      |


  @createPosts
  Scenario Outline: Create albums with specific User id
    * def testData = read('classpath:com/znsio/templates/createPostData.json')
    * def createPosts = karate.call('classpath:com/znsio/templates/createPostTemplate.feature@t_createPost', {"userId": <userId>, "title": <title>, "body": <body>, expectedStatus: <status>})
    * karate.log('response : ',createPosts.response)
    * match createPosts.response.title == <title>
    * match createPosts.response.body == <body>
    * match each createPosts.response[*].userId == userId
    Examples:
      | userId                              | title                               | body                                | status |
      | generateRandomNumber(4)             | generateAlphaNumericRandomString(7) | generateAlphaNumericRandomString(7) | 201    |
      | generateRandomNumber(4)             | generateAlphaNumericRandomString(7) | null                                | 201    |
      | generateAlphaNumericRandomString(7) | null                                | generateAlphaNumericRandomString(7) | 201    |
      | null                                | generateAlphaNumericRandomString(7) | generateAlphaNumericRandomString(7) | 201    |
      | null                                | null                                | null                                | 201    |

  @updatePosts
  Scenario Outline: Create albums with specific User id
    * def testData = read('classpath:com/znsio/templates/updatePostData.json')
    * def updatePosts = karate.call('classpath:com/znsio/templates/updatePostTemplate.feature@t_createPost', {"userId": <userId>, "title": <title>, "body": <body>, expectedStatus: <status>})
    * karate.log('response : ',updatePosts.response)
    * match each updatePosts.response[*].userId == userId
    * match updatePosts.response.title == <title>
    * match updatePosts.response.body == <body>
    Examples:
      | userId                              | title                               | body                                | status |
      | generateRandomNumber(4)             | generateAlphaNumericRandomString(7) | generateAlphaNumericRandomString(7) | 201    |
      | generateRandomNumber(4)             | generateAlphaNumericRandomString(7) | null                                | 201    |
      | generateAlphaNumericRandomString(7) | null                                | generateAlphaNumericRandomString(7) | 201    |
      | null                                | generateAlphaNumericRandomString(7) | generateAlphaNumericRandomString(7) | 201    |
      | null                                | null                                | null                                | 201    |
