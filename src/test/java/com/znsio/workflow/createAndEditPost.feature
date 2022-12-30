@jsonPlaceholder @prod
Feature: create and edit post

  Scenario: create post and edit title of the post

    * def createPostPayload = jsonPlaceholder.requestPayloads.createPostPayload
    * def editPostPayload = jsonPlaceholder.requestPayloads.editPostPayload
    * def expectedSchema = jsonPlaceholder.postSchema

    Given def createPostResult = karate.call('classpath:com/znsio/templates/typicodeTemplates.feature@t_createPosts', {createPostPayload: createPostPayload, status_code: 201}).response
    * karate.log("Newly created post for user : " , createPostResult)
    Then match createPostResult contains expectedSchema
    And match createPostResult contains createPostPayload

    * def postId = createPostResult.id
    Given def getPostResult = karate.call('classpath:com/znsio/templates/typicodeTemplates.feature@t_getPosts', {postId: postId, status_code: 200}).response
    * karate.log("Fetched post for user after creation: " , getPostResult)
    Then match getPostResult.fetchedPost contains expectedSchema
    And match getPostResult.fetchedPost contains createPostPayload
    And match getPostResult.fetchedPost.id = postId

    Given def editPostResult = karate.call('classpath:com/znsio/templates/typicodeTemplates.feature@t_editPosts', {userId: 1, editPostPayload: editPostPayload, status_code: 200})
    * karate.log("Edited post for user : " , editPostResult)
    Then match editPostResult contains expectedSchema
    And match editPostResult contains editPostPayload
    And match editPostResult.id == postId

    Given def getResultAfterEdit = karate.call('classpath:com/znsio/templates/typicodeTemplates.feature@t_getPosts', {postId: postId, status_code: 200})
    * karate.log("Fetched post for user after editing: " , getResultAfterEdit)
    Then match getResultAfterEdit contains expectedSchema
    And match getResultAfterEdit contains editPostPayload
    And match getResultAfterEdit.id = postId