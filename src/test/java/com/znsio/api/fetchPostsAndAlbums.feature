@UserPosts @prod
Feature: Fetch User Posts and Albums

  Background:
    * def testData = read('classpath:com/znsio/templates/userData.json')

  @getPosts
  Scenario Outline: Get posts with specific User id
    * def fetchPosts = karate.call('classpath:com/znsio/templates/fetchPostAndAlbums.feature@t_getPost', {"userId": <userId>, expectedStatus: <status>})
    * karate.log('response : ',fetchPosts.response)
    * match each fetchPosts.response == <expectedSchema>
    Examples:
      | userId                              | status | expectedSchema                 |
      | 1                                   | 200    | testData.expectedPostsResponse |
      | generateRandomNumber(4)             | 200    | testData.negativeResponse      |
      | generateAlphaNumericRandomString(7) | 200    | testData.negativeResponse      |
      | ""                                  | 200    | testData.negativeResponse      |

  @getAlbums
  Scenario Outline: Get albums with specific User id
    * def fetchAlbums = karate.call('classpath:com/znsio/templates/fetchPostAndAlbums.feature@t_getAlbums', {"userId": <userId>, expectedStatus: <status>})
    * karate.log('response : ',fetchAlbums.response)
    * match each fetchAlbums.response == <expectedSchema>
    Examples:
      | userId                              | status | expectedSchema                 |
      | 1                                   | 200    | testData.expectedAlbumResponse |
      | generateRandomNumber(4)             | 200    | testData.negativeResponse      |
      | generateAlphaNumericRandomString(7) | 200    | testData.negativeResponse      |
      | ""                                  | 200    | testData.negativeResponse      |
      | null                                | 200    | testData.negativeResponse      |

  @createPosts
  Scenario Outline: Create albums with specific User id
    * def createPosts = karate.call('classpath:com/znsio/templates/fetchPostAndAlbums.feature@t_createPost', {"userId": <userId>, "title": <title>, "body": <body>, expectedStatus: <status>})
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
    * def updatePosts = karate.call('classpath:com/znsio/templates/fetchPostAndAlbums.feature@t_createPost', {"userId": <userId>, "title": <title>, "body": <body>, expectedStatus: <status>})
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

    #Assignment 3
  @getComments
  Scenario Outline: Get comments with specific post id
    * def fetchComments = karate.call('classpath:com/znsio/templates/fetchPostAndAlbums.feature@t_getAlbums', {"userId": <postId>, expectedStatus: <status>})
    * karate.log('response : ',fetchComments.response)
    * match each fetchComments.response == <expectedSchema>
    Examples:
      | postId                              | status | expectedSchema                    |
      | 1                                   | 200    | testData.expectedCommentsResponse |
      | generateRandomNumber(4)             | 200    | testData.negativeResponse         |
      | generateAlphaNumericRandomString(7) | 200    | testData.negativeResponse         |
      | ""                                  | 200    | testData.negativeResponse         |
      | null                                | 200    | testData.negativeResponse         |