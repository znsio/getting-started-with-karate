Feature: Fetching user details

  Background:
    * print "base url "+env.baseUrl
    Given url env.baseUrl

  @t_getPost
  Scenario: Get Posts for particular user id
    Given path "/posts/"+userId
    When method Get
    * karate.log("Response status is ",responseStatus)
    * match responseStatus == 200
    * def listOfPosts = response

  @t_getComment
  Scenario: Get Comments for particular user id
    Given path "/comments/"+userId
    When method Get
    * karate.log("Response status is ",responseStatus)
    Then status  200
    * def listOfComments = response


  @t_getAlbum
  Scenario: Get Albums for particular user id
    And path '/albums'
    And param userId = userId
    When method Get
    Then match responseStatus == 200
    * def listOfAlbums = response

  @t_getPostQuery
  Scenario: Get Posts for particular user id
    Given path "/posts"
    And params {userId : '#(userId)', id : '#(id)'}
    When method Get
    * karate.log("Response status is ",responseStatus)
    * match responseStatus == status
    * def listOfPosts = response

  @t_getCommentQuery
  Scenario: Get Comments for particular post id
    Given path "/comments"
    And params {postId : '#(postId)', id : '#(id)'}
    When method Get
    * karate.log("Response status is ",responseStatus)
    * match responseStatus == status
    * def listOfComments = response


  @t_CreatePost
  Scenario: Create new post
    And path '/posts'
    And header content-type = 'application/json'
    And request input
    When method Post
    Then status 201
    * def post = response

  @t_EditPost
  Scenario: Edit already created post
    And path '/posts/'+id
    And request input
    When method Patch
    Then status 200
    * def edit = response

  @t_getPostForUserDetails
  Scenario: Get Posts for different user details
    And path '/posts'
    And param inputKey = inputValue
    When method Get
    Then match responseStatus == status

  @t_getCommentsForUserDetails
  Scenario: Get Comments for all the user
    * def key = inputKey
    And path '/comments'
    * karate.log(key)
    * karate.log(inputValue)
    And param '#(key)' = inputValue
    When method Get
    * karate.log("Comments are ",response)
#    Then match responseStatus == status