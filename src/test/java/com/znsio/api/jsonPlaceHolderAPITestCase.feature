@prod @postsAndComments
Feature: Negative test coverage for posts and comments

  Background:
    * def negativeSchema = []
    * def random_no = randomNumberInRange(1,10)
    * def random_alphaNum = generateAlphaNumericRandomString(10)


  Scenario Outline: Negative test coverage for posts in Query parameter

    * def postsSchema = {userId:#number , id:#number, title:'#string', body:'#string'}
    Given def postsResult = call read('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getPosts') {query: {userId:<userId_no>,id:<id_no>,title:<title_name>,body: <body_name>},'expectedStatus': <status_code>}
    And karate.log('postsResult.response---',postsResult.response)
    Then assert postsResult.responseStatus == <status_code>
    And match each postsResult.response == <schemaValidation>

    Examples:
      | userId_no | id_no     | title_name      | body_name       | status_code | schemaValidation |
      | random_no | random_no | " "             | " "             | 200         | negativeSchema   |
      | random_no | random_no | random_alphaNum | random_alphaNum | 200         | negativeSchema   |
      | random_no | random_no | "string title"  | "string body"   | 200         | negativeSchema   |
      | random_no | random_no | 789345          | 45725           | 200         | negativeSchema   |
      | null      | null      | null            | null            | 200         | postsSchema      |
      | random_no | ""        | ""              | ""              | 200         | negativeSchema   |

  @ignore
  Scenario Outline: Negative test coverage for comments in Query parameter

    * def commentsSchema = { postId:#number, id:#number, name:'#string', email:'#string', body:'#string'}
    Given def commentsResult = call read('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getComments'){query:{<key>:<value>},'expectedStatus':<status_code>}
    And karate.log('commentsResult.response---',commentsResult.response)
    Then assert commentsResult.responseStatus == <status_code>
    And match each commentsResult.response == <schemaValidation>

    Examples:
      | key    | value           | status_code | schemaValidation |
      | postId | " "             | 200         | negativeSchema   |
      | postId | null            | 200         | commentsSchema   |
      | postId | ""              | 200         | negativeSchema   |
      | postId | err             | 200         | negativeSchema   |
      | name   | random_alphaNum | 200         | negativeSchema   |
      | name   | 56785           | 200         | negativeSchema   |
      | name   | "string name"   | 200         | negativeSchema   |
