@CreateUpdate

  Feature: Create update and validate

    @createPost
    Scenario: Create and validate post
      * def title = generateAlphaNumericRandomString(5)
      * def body = generateAlphaNumericRandomString(10)
      * def userId = generateNumericRandomString(2)
      Given def createPostResponse = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_createPost',{title:'title',body:'body',userId:'userId'}).response
      * match createPostResponse.title == title
      * match createPostResponse.body == body
      * match createPostResponse.userId == userId
      And assert createdPostResponse.id > 100

      @updatePost
    Scenario: Fetch and Update post
        * def newTitle = generateAlphaNumericRandomString(5)
        * def userId = 1
        Given def getPostResponse = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getPostsById',{"userId": userId}).response
        Then match userPosts.response.id == userId
