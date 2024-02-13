@UserPosts @prod
Feature: Fetch User Albums and Comments

  @getAlbums
  Scenario Outline: Get albums with specific User id
    * def testData = read('classpath:com/znsio/templates/fetchAlbumData.json')
    * def fetchAlbums = karate.call('classpath:com/znsio/templates/fetchAlbumTemplate.feature@t_getAlbums', {"userId": <userId>, expectedStatus: <status>})
    * karate.log('response : ',fetchAlbums.response)
    * match each fetchAlbums.response == <expectedSchema>
    Examples:
      | userId                              | status | expectedSchema                 |
      | 1                                   | 200    | testData.expectedAlbumResponse |
      | generateRandomNumber(4)             | 200    | testData.negativeResponse      |
      | generateAlphaNumericRandomString(7) | 200    | testData.negativeResponse      |
      | ""                                  | 200    | testData.negativeResponse      |
      | null                                | 200    | testData.negativeResponse      |

  @getComments
  Scenario Outline: Get comments with specific post id
    * def testData = read('classpath:com/znsio/templates/fetchCommentsData.json')
    * def fetchComments = karate.call('classpath:com/znsio/templates/fetchCommentTemplate.feature@t_getAlbums', {"userId": <postId>, expectedStatus: <status>})
    * karate.log('response : ',fetchComments.response)
    * match each fetchComments.response == <expectedSchema>
    Examples:
      | postId                              | status | expectedSchema                    |
      | 1                                   | 200    | testData.expectedCommentsResponse |
      | generateRandomNumber(4)             | 200    | testData.negativeResponse         |
      | generateAlphaNumericRandomString(7) | 200    | testData.negativeResponse         |
      | ""                                  | 200    | testData.negativeResponse         |
      | null                                | 200    | testData.negativeResponse         |