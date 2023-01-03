@eat
Feature: Fetch posts, albums and comments of a user

  @jsonPlaceholder
  Scenario: Get list of Posts
    Given def listOfPosts = call read('classpath:com/znsio/templates/jsonPlaceholderTemplates.feature@t_getUserPosts') {"userId": 1, "expectedStatus": 200}
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
  Scenario Outline: Get comments with specific post id
    * def testData = read('classpath:com/znsio/templates/commentsAndPostsData.json')
    * def fetchComments = karate.call('classpath:com/znsio/templates/jsonPlaceholderTemplates.feature@t_getUserComments', {"postId": <postId>, "expectedStatus": <status>})
    * karate.log("This is my response",fetchComments.response)
    * match each fetchComments.response == <expectedSchema>
    Examples:
      | postId                              | status | expectedSchema                    |
      | 1                                   | 200    | testData.expectedCommentsResponse |
      | generateRandomNumber(4)             | 200    | testData.negativeResponse         |
      | generateAlphaNumericRandomString(7) | 200    | testData.negativeResponse         |
      | ""                                  | 200    | testData.negativeResponse         |
      | 'null'                              | 200    | testData.negativeResponse         |

  @getPosts
  Scenario Outline: Get posts with specific user id
    * def testData = read('classpath:com/znsio/templates/commentsAndPostsData.json')
    * def fetchPosts = karate.call('classpath:com/znsio/templates/jsonPlaceholderTemplates.feature@t_getUserPosts', {"userId": <userId>, "expectedStatus": <status>})
    * karate.log("This is my response",fetchPosts.response)
    * match each fetchPosts.response == <expectedSchema>
    Examples:
      | userId                              | status | expectedSchema                    |
      | 1                                   | 200    | testData.expectedPostsResponse    |
      | generateRandomNumber(4)             | 200    | testData.negativeResponse         |
      | generateAlphaNumericRandomString(7) | 200    | testData.negativeResponse         |
      | ""                                  | 200    | testData.negativeResponse         |
      | 'null'                              | 200    | testData.negativeResponse         |
