@userPost @prod
#TARGET_ENVIRONMENT=prod TYPE=workflow TAG=@userPost ./gradlew test
Feature: Create and update post using JSONPlaceHolder api
  Background:
    * def jsonData = read('classpath:com/znsio/templates/JSONPlaceHolderData.json')

  Scenario: Create a post and then update title
    Given def createPost = karate.call('classpath:com/znsio/templates/restUserTemplates.feature@t_createPost', {'payload': jsonData.Payload})
    Then print createPost
    And match createPost.response.id == 101
    And match createPost.response.title == "Abhishek-QECC"
    And match createPost.response == jsonData.createdPostSchema
    Then def updatePost = karate.call('classpath:com/znsio/templates/restUserTemplates.feature@t_updatePost', {'Id': createPost.response.id, 'payload': jsonData.Payload_Patch})
    And print updatePost
    Then match updatePost.response.title == "Abhishek-QECC-modified"
