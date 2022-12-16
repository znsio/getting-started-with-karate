@prod
Feature: Test Posts and comments of users

  Background:
    Given url env.baseUrl
    * def schema = read('classpath:com/znsio/userDetails.json');

  @commentsForUserDetails
  Scenario Outline: Fetch and test all the comments
    * def userComments = karate.call('classpath:com/znsio/templates/jsonUserDetailsTemplate.feature@t_getCommentQuery',{postId:<postId>,"status": <status>})
    * karate.log("Fetched all the Comments ", userComments)
    * match userComments.responseStatus == <status>
    * match each userComments.response[*] == <schema>

    Examples:
      | postId  |status|schema                      |
      |      1   |200   | schema.getCommentSchema   |
      |    101   |404   | schema.getInvalidSchema   |
      |  null  |404     |schema.getInvalidSchema    |


  @postsForUserDetails
  Scenario Outline: Fetch and test all the posts
    * def userPosts = karate.call('classpath:com/znsio/templates/jsonUserDetailsTemplate.feature@t_getPostQuery',{userId:<userId>,"status": <status>})
    * karate.log("Fetched all the posts ", userPosts)
    * match userPosts.responseStatus == <status>
    * match each userPosts.response[*] == <schema>

    Examples:
      | userId  |status|schema                      |
      |      1   |200   | schema.getPostSchema       |
      |    101   |404   | schema.getInvalidSchema    |
      |  null  |404     |schema.getInvalidSchema    |


#  Reference

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