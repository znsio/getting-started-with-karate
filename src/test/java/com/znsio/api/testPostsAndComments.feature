@prod
Feature: Test Posts and comments of users

  Background:
    Given url env.baseUrl

  @testComments
  Scenario Outline: Fetch and test all the comments
    * def schema = read('classpath:com/znsio/templates/getCommentsApi.json');
    * def userComments = karate.call('classpath:com/znsio/templates/jsonUserDetailsTemplate.feature@t_getCommentQuery',{postId:<postId>, id : <id> , "status": <status>})
    * karate.log("Fetched all the Comments ", userComments)
    * match userComments.responseStatus == <status>
    * match each userComments.response[*] == <schema>

    #increase test coverage (add id also in examples section)
    Examples:
      | postId |id    |status|schema                      |
      |      1 | 1    |200   | schema.getCommentSchema    |
      |    101 | 1    |404   | schema.getInvalidSchema    |
      |  100   |501   |404   |schema.getInvalidSchema     |
      |&%$#@   | 1    | 404  | schema.getInvalidSchema    |
      |    1   |&%$#@ | 404  | schema.getInvalidSchema    |


  @testPosts
  Scenario Outline: Fetch and test all the posts
    * def schema = read('classpath:com/znsio/templates/getPostApi.json');
    * def userPosts = karate.call('classpath:com/znsio/templates/jsonUserDetailsTemplate.feature@t_getPostQuery',{userId:<userId>,id : <id>,"status": <status>})
    * karate.log("Fetched all the posts ", userPosts)
    * match userPosts.responseStatus == <status>
    * match each userPosts.response[*] == <schema>
    * match each userPosts.response[*].id == <id>
    #increase test coverage (add id also in examples section)
    Examples:
      | userId |id |status|schema                      |
      |      1 | 1 |200   | schema.getPostSchema       |
      |    101 | 1 |404   | schema.getInvalidSchema    |
      |  null  | 1 |404   |schema.getInvalidSchema     |
      |&%$#@   | 1 | 404 | schema.getInvalidSchema    |
      |        | 1 | 404  | schema.getInvalidSchema    |


#  Reference
#  @commentsQuery
#  Scenario Outline: Fetch and test all the comments
#    * def userComments = karate.call('classpath:com/znsio/templates/jsonUserDetailsTemplate.feature@t_getCommentsForUserDetails',{'inputKey':'<inputKey>',inputValue: <inputValue>})
#    * karate.log("Fetched all the Comments ", userComments)
#    * match userComments.responseStatus == <status>
#    * match each userComments.response[*] == <schema>
#
#    Examples:
#      |inputKey  | inputValue  |status|schema                      |
#      | userId   |      1      |200   | schema.getPostSchema       |
#      | userId   |    101      |404   | schema.getInvalidSchema    |
#      | userId   | null        |404   | schema.getInvalidSchema    |
#      | id       |      1      |200   | schema.getPostSchema       |
#      | id       |    101      |404   | schema.getInvalidSchema    |
#      | id       | null        |404   | schema.getInvalidSchema    |
#      | abvcf    |      1       |404   | schema.getInvalidSchema    |
#      | 46757    |    1         |404   | schema.getInvalidSchema    |
#      | $%^&*    | 1            |404   | schema.getInvalidSchema    |
#    Examples:
#      |inputKey  | inputValue  |status|schema                      |
#      | postId |      1      |200   | schema.getCommentSchema    |
#      | postId |    101      |404   | schema.getInvalidSchema    |
#      | postId | null        |404   | schema.getInvalidSchema    |
#      | id       |      1      |200   | schema.getCommentSchema    |
#      | id       |    501      |404   | schema.getInvalidSchema    |
#      | id       | null        |404   | schema.getInvalidSchema    |
#      | abvcf    |      1      |404   | schema.getInvalidSchema    |
#      | 46757    |    1        |404   | schema.getInvalidSchema    |
#      | $%^&*    | 1           |404   | schema.getInvalidSchema    |