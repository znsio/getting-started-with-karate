@prod @jsonPlaceholder
Feature: Fetch Posts and Albums

  Scenario: Get posts with id 1
    Given def postsWithUserIdOne = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getAllPosts',{ userId: 1, expectedStatus: 200 }).response
    Then karate.log("posts with userId:1 ",postsWithUserIdOne)
    Then match each postsWithUserIdOne..userId == 1
    Then match each postsWithUserIdOne == {userId:1 , id:'#number', title:'#string', body:'#string'}

  Scenario: Get albums with id 1
    Given def albumsWithIdOne = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getAllAlbums',{ userId: 1, expectedStatus: 200 }).response
    Then karate.log("albums with id:1 ",albumsWithIdOne)
    Then match each albumsWithIdOne..userId == 1
    Then match each albumsWithIdOne == {userId:1 , id:'#number', title:'#string'}

  Scenario Outline: To verify functionality of GET /posts endpoint
    * def positiveCaseResponseSchema = jsonPlaceholderData.posts.schema
    * def negativeCaseResponseSchema = jsonPlaceholderData.posts.negativeResponseSchema
    * def query = {userId:<userId> , id:<id>, title:<title>, body:<body>}
    * def updateQuery =
    """
    (key, value) => {if(value == '')delete query[key];}
    """
    * karate.forEach(query,updateQuery);
    Given def getCallResponse = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getPostsByParams',{ params: query, expectedStatus: <expectedStatus>}).response
    Then karate.log("posts <TestCase>",getCallResponse)
    Then match each getCallResponse contains query
    Then match each getCallResponse == <expectedSchema>

    Examples:
      | TestCase                                         | userId | id     | title                                                                        | body                                                                                                                                                                | expectedStatus | expectedSchema             |
      | All Parameters                                   | 1      | 1      | 'sunt aut facere repellat provident occaecati excepturi optio reprehenderit' | 'quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto' | 200            | positiveCaseResponseSchema |
      | Search by userId:<userId> and id:<id>            | 10     | 91     | ''                                                                           | ''                                                                                                                                                                  | 200            | positiveCaseResponseSchema |
      | Search by userId:<userId>                        | 1      | ''     | ''                                                                           | ''                                                                                                                                                                  | 200            | positiveCaseResponseSchema |
      | Search by id:<id>                                | ''     | 1      | ''                                                                           | ''                                                                                                                                                                  | 200            | positiveCaseResponseSchema |
      | Search by null userId:<userId>                   | 'null' | ''     | ''                                                                           | ''                                                                                                                                                                  | 404            | negativeCaseResponseSchema |
      | Search by alphanumeric userId:<userId>           | 'a123' | ''     | ''                                                                           | ''                                                                                                                                                                  | 404            | negativeCaseResponseSchema |
      | Search by negative userId:<userId>               | -1     | ''     | ''                                                                           | ''                                                                                                                                                                  | 404            | negativeCaseResponseSchema |
      | Search by specialChars+number as userId:<userId> | '@123' | ''     | ''                                                                           | ''                                                                                                                                                                  | 404            | negativeCaseResponseSchema |
      | Search by alphanumeric id:<id>                   | 'a123' | ''     | ''                                                                           | ''                                                                                                                                                                  | 404            | negativeCaseResponseSchema |
      | Search by null id:<id>                           |        | 'null' | ''                                                                           | ''                                                                                                                                                                  | 404            | negativeCaseResponseSchema |
      | Search by negative id:<id>                       |        | -20    | ''                                                                           | ''                                                                                                                                                                  | 404            | negativeCaseResponseSchema |
      | Search by alphanumeric id:<id>                   |        | '#e##' | ''                                                                           | ''                                                                                                                                                                  | 404            | negativeCaseResponseSchema |
      | Search by invalid title:<title>                  | ''     | ''     | '@testAlphnumer!cT!tl3'                                                      | ''                                                                                                                                                                  | 404            | negativeCaseResponseSchema |
      | Search by null title:<title>                     | ''     | ''     | 'null'                                                                       | ''                                                                                                                                                                  | 404            | negativeCaseResponseSchema |
      | search by partial title match: <title>           | ''     | ''     | 'dolorem dolore est'                                                         | ''                                                                                                                                                                  | 404            | negativeCaseResponseSchema |
      | Search by null body:<body>                       | ''     | ''     | ''                                                                           | 'null'                                                                                                                                                              | 404            | negativeCaseResponseSchema |
      | Search by invalid body:<body>                    | ''     | ''     | ''                                                                           | '@testAlphnumer!cb0d¥'                                                                                                                                              | 404            | negativeCaseResponseSchema |
      | search by partial body match: <body>             | ''     | ''     | ''                                                                           | 'dignissimos aperiam dolorem'                                                                                                                                       | 404            | negativeCaseResponseSchema |

  Scenario Outline: To verify functionality of GET /comments endpoint
    * def positiveCaseResponseSchema = jsonPlaceholderData.comments.schema
    * def negativeCaseResponseSchema = jsonPlaceholderData.comments.negativeResponseSchema
    * def query = {postId:<postId> , id:<id>, name:<name>, email:<email>,body:<body>}
    * def updateQuery =
    """
    (key, value) => {if(value == '')delete query[key];}
    """
    * karate.forEach(query,updateQuery);
    Given def getCallResponse = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getCommentsByParams',{ params: query, expectedStatus: <expectedStatus>}).response
    Then karate.log("comments <TestCase>",getCallResponse)
    Then match each getCallResponse contains query
    Then match each getCallResponse == <expectedSchema>

    Examples:
      | TestCase                                          | postId | id     | name                                        | email                    | body                                                                                                                                                                          | expectedStatus | expectedSchema             |
      | All Parameters                                    | 1      | 2      | "quo vero reiciendis velit similique earum" | "Jayne_Kuhic@sydney.com" | "est natus enim nihil est dolore omnis voluptatem numquam\net omnis occaecati quod ullam at\nvoluptatem error expedita pariatur\nnihil sint nostrum voluptatem reiciendis et" | 200            | positiveCaseResponseSchema |
      | Search by postId:<postId> and id:<id>             | 1      | 1      | ''                                          | ''                       | ''                                                                                                                                                                            | 200            | positiveCaseResponseSchema |
      | search by postId:<postId>                         | 1      | ''     | ''                                          | ''                       | ''                                                                                                                                                                            | 200            | positiveCaseResponseSchema |
      | search by id:<id>                                 | ''     | 1      | ''                                          | ''                       | ''                                                                                                                                                                            | 200            | positiveCaseResponseSchema |
      | search by alphanumeric postId:<postId>            | 'a111' | ''     | ''                                          | ''                       | ''                                                                                                                                                                            | 200            | positiveCaseResponseSchema |
      | search by null as a postId:<postId>               | 'null' | ''     | ''                                          | ''                       | ''                                                                                                                                                                            | 404            | negativeCaseResponseSchema |
      | search by negative postId:<postId>                | -1     | ''     | ''                                          | ''                       | ''                                                                                                                                                                            | 404            | negativeCaseResponseSchema |
      | search by specialChars+numbers as postId:<postId> | '@123' | ''     | ''                                          | ''                       | ''                                                                                                                                                                            | 404            | negativeCaseResponseSchema |
      | search by alphanumeric id:<id>                    |        | 'a111' | ''                                          | ''                       | ''                                                                                                                                                                            | 404            | positiveCaseResponseSchema |
      | search by null as a id:<id>                       | ''     | 'null' | ''                                          | ''                       | ''                                                                                                                                                                            | 404            | negativeCaseResponseSchema |
      | search by negative id:<id>                        | ''     | -1     | ''                                          | ''                       | ''                                                                                                                                                                            | 404            | negativeCaseResponseSchema |
      | search by specialChars+numbers as id:<id>         | ''     | '@123' | ''                                          | ''                       | ''                                                                                                                                                                            | 404            | negativeCaseResponseSchema |
      | search by invalid name:<name>                     | ''     | ''     | 'testUser'                                  | ''                       | ''                                                                                                                                                                            | 404            | negativeCaseResponseSchema |
      | search by name:<name>                             | ''     | ''     | 'null'                                      | ''                       | ''                                                                                                                                                                            | 404            | negativeCaseResponseSchema |
      | search by invalid email:<email>                   | ''     | ''     | ''                                          | 'Jayne_Kuhic@'           | ''                                                                                                                                                                            | 404            | negativeCaseResponseSchema |
      | search by email:<email>                           | ''     | ''     | ''                                          | 'null'                   | ''                                                                                                                                                                            | 404            | negativeCaseResponseSchema |
      | search by partial match body content:<body>       | ''     | ''     | ''                                          | ''                       | 'est natus enim nihil est dolore'                                                                                                                                             | 404            | negativeCaseResponseSchema |
      | search by non-existing body content:<body>        | ''     | ''     | ''                                          | ''                       | 'non existing body content'                                                                                                                                                   | 404            | negativeCaseResponseSchema |
      | search by body:<body>                             | ''     | ''     | ''                                          | ''                       | 'null'                                                                                                                                                                        | 404            | negativeCaseResponseSchema |
