@prod @postsAndComments
Feature: Negative test coverage for posts and comments

  Background:
    * def random_no = randomNumberInRange(1,10)
    * def random_alphaNum = generateAlphaNumericRandomString(10)


  Scenario Outline: Negative test coverage for posts in Query parameter

    Given def postsResult = call read('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getPosts') {query: {userId:<userId_no>,id:<id_no>,title:<title_name>,body: <body_name>},'expectedStatus': <status_code>}
    And karate.log('postsResult.response---',postsResult.response)
    And match each postsResult.response == <schema>

    Examples:
      | userId_no | id_no     | title_name      | body_name       | status_code | schema                               |
      | random_no | random_no | " "             | " "             | 200         | jsonPlaceHolderSchema.negativeSchema |
      | random_no | random_no | random_alphaNum | random_alphaNum | 200         | jsonPlaceHolderSchema.negativeSchema |
      | random_no | random_no | "string title"  | "string body"   | 200         | jsonPlaceHolderSchema.negativeSchema |
      | random_no | random_no | 789345          | 45725           | 200         | jsonPlaceHolderSchema.negativeSchema |
      | null      | null      | null            | null            | 200         | jsonPlaceHolderSchema.postsSchema    |
      | random_no | ""        | ""              | ""              | 200         | jsonPlaceHolderSchema.negativeSchema |


  Scenario Outline: Negative test coverage for comments in Query parameter

    Given def commentsResult = call read('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getComments'){query:{<key>:<value>},'expectedStatus':<status_code>}
    And karate.log('commentsResult.response---',commentsResult.response)
    And match each commentsResult.response == <schemas>

    Examples:
      | key    | value           | status_code | schemas                              |
      | postId | " "             | 400         | jsonPlaceHolderSchema.negativeSchema |
      | postId | null            | 400         | jsonPlaceHolderSchema.commentsSchema |
      | postId | ""              | 200         | jsonPlaceHolderSchema.negativeSchema |
      | postId | err             | 200         | jsonPlaceHolderSchema.negativeSchema |
      | name   | random_alphaNum | 200         | jsonPlaceHolderSchema.negativeSchema |
      | name   | 56785           | 200         | jsonPlaceHolderSchema.negativeSchema |
      | name   | "string name"   | 200         | jsonPlaceHolderSchema.negativeSchema |
      | email  | "@gardner.biz"  | 400         | jsonPlaceHolderSchema.negativeSchema |
      | email  | null            | 404         | jsonPlaceHolderSchema.negativeSchema |
      | email  | "gardner56"     | 400         | jsonPlaceHolderSchema.negativeSchema |
      | email  | 65789           | 400         | jsonPlaceHolderSchema.negativeSchema |
      | body   | "laudantium"    | 404         | jsonPlaceHolderSchema.negativeSchema |
      | body   | "1234567"       | 404         | jsonPlaceHolderSchema.negativeSchema |
      | body   | ""              | 404         | jsonPlaceHolderSchema.negativeSchema |
      | body   | null            | 404         | jsonPlaceHolderSchema.negativeSchema |






