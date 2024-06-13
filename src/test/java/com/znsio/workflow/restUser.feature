@userPost @prod
#TARGET_ENVIRONMENT=prod TYPE=workflow TAG=@userPost ./gradlew test
Feature: Create and update post using JSONPlaceHolder api
  Background:
    * def jsonData = read('classpath:com/znsio/templates/JSONPlaceHolderData.json')

  Scenario: Create a post and then update title
    Given def createPost = karate.call('classpath:com/znsio/templates/restUserTemplates.feature@t_createPost', {'payload': jsonData.Payload})
    Then karate.log("Response for the post created", createPost.response)
    And match createPost.response.id == jsonData.id
    And match createPost.response.title == "Abhishek-QECC"
    And match createPost.response == jsonData.createdPostSchema
    Given def getPosts = karate.call('classpath:com/znsio/templates/restUserTemplates.feature@t_getUserPosts', {'user_Id': createPost.response.userId})
    And match getPosts.response.length == '#notpresent'
    Then def updatePost = karate.call('classpath:com/znsio/templates/restUserTemplates.feature@t_updatePost', {'Id': createPost.response.id, 'payload': jsonData.Payload_Patch})
    Then karate.log("Response for the post updated", updatePost.response)
    Then match updatePost.response.title == "Abhishek-QECC-modified"
    Given def getPosts = karate.call('classpath:com/znsio/templates/restUserTemplates.feature@t_getUserPosts', {'user_Id': createPost.response.userId})
    Then match getPosts.response.title == "Abhishek-QECC-modified"
