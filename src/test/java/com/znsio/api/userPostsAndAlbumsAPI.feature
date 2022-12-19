@userPost @prod
  #  TARGET_ENVIRONMENT=prod TYPE=api TAG=@userPosts ./gradlew test

  Feature: Fetch user details
    Background:
      * def userId = 1
      * def statusOKSuccess = 200
      * def jsonData = read('classpath:com/znsio/templates/jsonData.json')

      @getUserPosts
        Scenario: Get posts for a specific user
        Given def getUserPosts = karate.call('classpath:com/znsio/templates/userTemplates.feature@t_getUserPosts',{'user_Id': userId})
        Then karate.log("Response from GET request for posts : ", getUserPosts.response)
        And match each getUserPosts.response[*].userId == userId
        And match each getUserPosts.response[*] == jsonData.postSchema

      @getUserAlbums
        Scenario: Get albums for a specific user
        Given def getUserAlbums = karate.call('classpath:com/znsio/templates/userTemplates.feature@t_getUserAlbums',{'user_Id': userId})
        Then karate.log("Response from get request for albums :", getUserAlbums.response)
        And match each getUserAlbums.response[*].userId = userId
        And match each getUserAlbums.response[*] == jsonData.albumSchema
