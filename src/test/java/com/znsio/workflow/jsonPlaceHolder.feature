@prod @createAndUpdate
Feature: verify the created post and update

  Scenario: Create and validate for new post and update

    Given def createPostResult = call read('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_createPost'){'payload': env.createPayload,ecpectedStatus: 201}
    Then match createPostResult.response.userId == env.createPayload.userId
    And match createPostResult.response.title == env.createPayload.title
    And match createPostResult.response.Body == env.createPayload.Body
    And match createPostResult.response contains {"userId":'#number',"id":'#number',"title":'#string',"body":'#string'}
    When def getCreatedResult = call read('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getPosts'){'query': createPostResult.response.id,ecpectedStatus: 200}
    Then match getCreatedResult.response contains {"userId":'#number',"id":'#number',"title":'#string',"body":'#string'}
    When def resultofUpdate = call read('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_updatePost'){'query': getNewPostResult.response.id ,payload: env.updatePayload,ecpectedStatus: 200}
    Then match resultofUpdate.response.title == env.updatePayload
    And def getUpdateQuery = createPostResult.response.id
    When def updateResult = call read('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getPosts'){'query': getUpdateQuery,ecpectedStatus: 200}
    Then updateResult.response.userId == createPostResult.response.userId
    And updateResult.response.id == createPostResult.response.id
    And updateResult.response.title == resultofUpdate.response.title


