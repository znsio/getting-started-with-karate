 @prod @postsandAlbums
Feature: Getting all the posts and albums with UserID specfication

  @posts
  Scenario: Get all the posts of employees with UserID 1

    When  def PostsWithUserIdOneResult = call read('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getPostsEmployees')
    And karate.log (PostsWithUserIdOneResult)
    # validate the core result and schema of response
    Then match PostsWithUserIdOneResult.response[*].userId contains [1]
    And match PostsWithUserIdOneResult.response[*] contains {"userId":'#number',"id":'#number',"title":'#string',"body":'#string'}
    * def jsonpostsresult = read('../templates/allpostResponse.json')
    And match jsonpostsresult[9] contains any {"userId": 1}


  @albums
  Scenario: Get all the albums of employees with UserID 1

    When def albumsWithUserIdOneResult = call read('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getAlbumsEmployees')
    And karate.log(albumsWithUserIdOneResult)
    #value match must in []
    Then match albumsWithUserIdOneResult.response[*].userId contains [1]
    And match albumsWithUserIdOneResult.response[*] contains {"userId":'#number',"id":'#number',"title":'#string'}
    * def jsonalbumsresult = read('../templates/allAlbumsResponse.json')
    And match jsonalbumsresult[9] contains any {"userId": 1}