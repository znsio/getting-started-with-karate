@prod @jsonPlaceholder
Feature: API Workflow to Create and Edit Posts

  Scenario: Verify Create and Edit of Posts

    * def createPostsBody = jsonPlaceholderData.posts.body
    * def expectedSchema =  jsonPlaceholderData.posts.schema
    Given def createPostsResponse = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_createPost',{ body: createPostsBody, expectedStatus : 201}).response
    Then karate.log("createPostsResponse: ", createPostsResponse)
    Then match createPostsResponse contains createPostsBody
    Then match  createPostsResponse == expectedSchema

    * def createPostsResponseId = createPostsResponse.id
    Given def getPostsResult = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getPosts',{ id: createPostsResponseId, expectedStatus: 200 }).response
    Then karate.log("Get Posts Result: ",getPostsResult)
    Then match getPostsResult contains createPostsBody
    Then match  getPostsResult == expectedSchema

    * def editPostsBody = jsonPlaceholderData.posts.update.body
    Given def editPostsResponse = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_editPost',{ id: createPostsResponseId, body: editPostsBody, expectedStatus : 200}).response
    Then karate.log("Edit Posts Response: ", editPostsResponse)
    Then assert editPostsResponse.title == editPostsBody.title
    Then assert editPostsResponse.userId == createPostsBody.userId
    Then assert editPostsResponse.body == createPostsBody.body
    Then match  editPostsResponse == expectedSchema

    Given def getPostsAfterEdit = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getPosts',{ id: createPostsResponseId, expectedStatus: 200 }).response
    Then karate.log("Get Posts After Edit: ",getPostsAfterEdit)
    Then assert getPostsAfterEdit.title == editPostsBody.title
