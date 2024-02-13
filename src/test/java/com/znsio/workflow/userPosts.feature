@prod @userWorkFlow
  #TARGET_ENVIRONMENT=prod TYPE=workflow TAG=@userPost ./gradlew test

  Feature: Create and Update post - JsonPlaceHolder API
    Background: 
      * def jsonPostsData = read('classpath:com/znsio/templates/postsData.json')

      @createAndUpdatePost
      Scenario: Create a post and update title later
        Given def createPost = karate.call('classpath:com/znsio/templates/userTemplates.feature@t_createPost', {'payload': jsonPostsData.Payload})
        Then karate.log('Created post response', createPost.response)
        And match createPost.response.id == jsonPostsData.id
        And match createPost.response.title == jsonPostsData.Payload.title
        And match createPost.response == jsonPostsData.createdPostSchema
        Given def getPosts = karate.call('classpath:com/znsio/templates/userTemplates.feature@t_getUserPosts', {'user_Id': createPost.response.userId,'status':jsonPostsData.status})
        And match getPosts.response.length == '#notpresent'
        Then def updatePost = karate.call('classpath:com/znsio/templates/userTemplates.feature@t_updatePost', {'Id': jsonPostsData.id, 'payload': jsonPostsData.Payload_patch})
        Then karate.log("Response for the updated post", updatePost.response)
        Then match updatePost.response.title == Payload_patch.title
        Given def getPosts = karate.call('classpath:com/znsio/templates/userTemplates.feature@t_getUserPosts',{'user_Id': createPost.response.userId,'status':jsonPostsData.status})
        Then match getPosts.response.title == "#notpresent"
