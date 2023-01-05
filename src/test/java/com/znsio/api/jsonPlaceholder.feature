@eat
Feature: Fetch posts, albums and comments of a user

  @jsonPlaceholder
  Scenario: Get list of Posts with specific user id
    Given def listOfPosts = call read('classpath:com/znsio/templates/jsonPlaceholderTemplates.feature@t_getUserPosts') {"query_params": {"userId":1}, "expectedStatus": 200}
    Then  karate.log("listOfPosts: " + listOfPosts.data.length)
    And karate.log("This is my list of posts-------------> ", listOfPosts.data)
    And match listOfPosts.data[*].userId contains [1]

  @jsonPlaceholder
  Scenario: Get list of Albums
    Given def listOfAlbums = call read('classpath:com/znsio/templates/jsonPlaceholderTemplates.feature@t_getUserAlbums') {userId: 1}
    Then karate.log("listOfAlbums: " + listOfAlbums.data.length)
    And karate.log("This is my list of albums-------------> ", listOfAlbums.data)
    And match listOfAlbums.data[*].userId contains [1]

  @getComments
  Scenario Outline: Get all comments
    * def testData = read('classpath:com/znsio/templates/commentsAndPostsData.json')
    * def fetchComments = karate.call('classpath:com/znsio/templates/jsonPlaceholderTemplates.feature@t_getUserComments', {"query_params": {<key> : <value>}, "expectedStatus": <status>})
    * karate.log("This is my response",fetchComments.response)
    * match each fetchComments.response == <expectedSchema>
    * match each <statement>
    Examples:
      | key    | value                                | status | expectedSchema                  | statement                                                                     |
      | postId | 1                                    | 200    | testData.expectedCommentsSchema | fetchComments.response contains {postId:1}                                    |
      | postId | generateRandomNumber(4)              | 200    | testData.negativeResponseSchema | fetchComments.response == []                                                  |
      | postId | generateAlphaNumericRandomString(7)  | 200    | testData.negativeResponseSchema | fetchComments.response == []                                                  |
      | postId | ""                                   | 200    | testData.negativeResponseSchema | fetchComments.response == []                                                  |
      | postId | 'null'                               | 200    | testData.negativeResponseSchema | fetchComments.response == []                                                  |
      | id     | 500                                  | 200    | testData.expectedCommentsSchema | fetchComments.response contains testData.expectedCommentsResponse.uniqueId[0] |
      | id     | -1                                   | 200    | testData.negativeResponseSchema | fetchComments.response == []                                                  |
      | id     | 'null'                               | 200    | testData.negativeResponseSchema | fetchComments.response == []                                                  |
      | name   | generateAlphaNumericRandomString(10) | 200    | testData.negativeResponseSchema | fetchComments.response == []                                                  |
      | email  | generateAlphaNumericRandomString(10) | 200    | testData.negativeResponseSchema | fetchComments.response == []                                                  |

  @getPosts
  Scenario Outline: Get all posts
    * def testData = read('classpath:com/znsio/templates/commentsAndPostsData.json')
    * def fetchPosts = karate.call('classpath:com/znsio/templates/jsonPlaceholderTemplates.feature@t_getUserPosts', {"query_params": {<key> : <value>}, "expectedStatus": <status>})
    * karate.log("This is my response",fetchPosts.response)
    * match each fetchPosts.response == <expectedSchema>
    * match each <statement>
    Examples:
      | key    | value                                | status | expectedSchema                  | statement                                                               |
      | userId | 1                                    | 200    | testData.expectedPostsSchema    | fetchPosts.response contains {userId:1}                                 |
      | userId | generateRandomNumber(4)              | 200    | testData.negativeResponseSchema | fetchPosts.response == []                                               |
      | userId | generateAlphaNumericRandomString(7)  | 200    | testData.negativeResponseSchema | fetchPosts.response == []                                               |
      | userId | ""                                   | 200    | testData.negativeResponseSchema | fetchPosts.response == []                                               |
      | userId | 'null'                               | 200    | testData.negativeResponseSchema | fetchPosts.response == []                                               |
      | id     | 100                                  | 200    | testData.expectedPostsSchema    | fetchPosts.response contains testData.expectedPostsResponse.uniqueId[0] |
      | id     | -1                                   | 200    | testData.negativeResponseSchema | fetchPosts.response == []                                               |
      | id     | 'null'                               | 200    | testData.negativeResponseSchema | fetchPosts.response == []                                               |
      | title  | generateAlphaNumericRandomString(10) | 200    | testData.negativeResponseSchema | fetchPosts.response == []                                               |
