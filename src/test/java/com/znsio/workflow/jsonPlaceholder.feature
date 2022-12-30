@eat @jsonPlaceholder
#TARGET_ENVIRONMENT=eat TYPE=workflow TAG=@jsonPlaceholder ./gradlew test

#I should be able to create a post and then edit the created post
#Assignment - 2
#- Create a post
#- Get the created post and validate the details
#- Update the post title
#- Get that post and validate if the title is updated.
Feature: Create and update post of a user
  Background:
    * def jsonData = jsonPlaceholderData

  Scenario: Create a post and then update title
    Given def createdPost = karate.call('classpath:com/znsio/templates/restUserTemplates.feature@t_createUserPost', {'request': jsonData.payload})
    Then print createdPost
    And match createdPost.response.id == 101
    And match createdPost.response.title == "foo"
    And match createdPost.response.body == "bar"
    And match createdPost.response == jsonData.postSchema

    Then def getCreatedPost = karate.call('classpath:com/znsio/templates/restUserTemplates.feature@t_getSinglePost', {'id': createPosted.response.id})
    And match getCreatedPost.response.id == 101
    And match getCreatedPost.response.title == "foo"
    And match getCreatedPost.response.body == "bar"

    Then def updatedPost = karate.call('classpath:com/znsio/templates/restUserTemplates.feature@t_updateUserPost', {'id': createPosted.response.id, 'request': payloadPatch.title})
    And print updatedPost
    Then match updatedPost.response.title == "foo-updated"

    Then def getCreatedPost = karate.call('classpath:com/znsio/templates/restUserTemplates.feature@t_getSinglePost',{'id': updatedPost.response.id})
    And match getCreatedPost.response.title == "foo-updated"