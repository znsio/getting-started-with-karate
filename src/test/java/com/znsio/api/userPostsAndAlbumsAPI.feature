@userPostsandAlbums @prod
  #  TARGET_ENVIRONMENT=prod TYPE=api TAG=@getUserPosts ./gradlew test

  Feature: Fetch user details wrt jsonPlaceHolder api
    Background:
      * def jsonPostsData = read('classpath:com/znsio/templates/postsData.json')
      * def jsonAlbumsData = read('classpath:com/znsio/templates/albumsData.json')

      @getUserPosts
        Scenario Outline: Get posts for a specific user
        Given def getUserPosts = karate.call('classpath:com/znsio/templates/userTemplates.feature@t_getUserPosts',{'user_Id' : <userId>,status:<status>})
        Then karate.log("Response from GET request for posts : ", getUserPosts.response)
        And match each getUserPosts.response[*].userId == <userId>
        And match each getUserPosts.response[*] == jsonPostsData.postSchema
        Examples:
          | userId | status |
          | 1      | 200    |
          | 110    | 404    |
          |        | 404    |
          | *^$#^& | 400    |
          | null   | 400    |

    @getUserAlbums
        Scenario Outline: Get albums for a specific user
        Given def getUserAlbums = karate.call('classpath:com/znsio/templates/userTemplates.feature@t_getUserAlbums',{user_Id: <userId>,"status":<status>})
        Then karate.log("Response from get request for albums :", getUserAlbums.response)
        And match each getUserAlbums.response[*].userId == <userId>
        And match each getUserAlbums.response[*] == jsonAlbumsData.albumSchema
        Examples:
          | userId | status |
          | 1      | 200    |
          | 110    | 404    |
          |        | 404    |
          | *^$#^& | 404    |
          | null   | 400    |

