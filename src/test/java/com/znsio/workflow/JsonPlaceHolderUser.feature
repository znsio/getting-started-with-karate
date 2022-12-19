@prod
  #TARGET_ENVIRONMENT=prod TYPE=workflow TAG=@userPost ./gradlew test

  Feature: Create and Update post - JsonPlaceHolder API
    Background: 
      * def jsonData = read('classpath:com/znsio/templates/jsonData.json')

      Scenario: Create a post and update title later
        Given def createPost = karate.call('classpath:com/znsio/templates/userTemplates.feature@t_createPost', {'payload': jsonData.Payload})
        Then karate.log('Created post response', createPost.response)
        And match createPost.response.id == 101
        And match createPost.response.title == ""
        And match createPost.response == jsonData.createdPostSchema
        Then def updatePost = karate.call('classpath:com/znsio/templates/userTemplates.feature@t_updatePost', {'Id': createPost.response.id, 'payload': jsonData.Payload_Patch})
        Then karate.log("Response for the post updated", updatePost.response)
        Then match updatePost.response.title == ""