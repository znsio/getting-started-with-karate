@template
  Feature: API test for https://jsonplaceholder.typicode.com

    Background:
      Given url env.jsonPlaceHolderUrl
      And print "JSONPlaceHolderURL : " + env.jsonPlaceHolderUrl


    @getPostsOfUser
    Scenario: Get posts of a user
      Given def path = "/posts"
      And print "Get posts from URl " + env.jsonPlaceHolderUrl + path
      And path path
      And param userId = userId
      When method GET
      Then status 200
      And def postsOfUser = response
      And print "Posts of user with ID " + userId + " : " , postsOfUser
      And def fun =
      """
      function(responseArray){
      for (let i = 0; i < responseArray.length; i++){
          if(responseArray[i].userId != userId) return false
          else return true
      }
      }
      """
      And def checkUserIdInPosts = fun(postsOfUser)

    @getCommentsOfPost
    Scenario: Get Comments of a post
      Given def path = "/comments"
      And print "Get comments of Post from URl " + env.jsonPlaceHolderUrl + path
      And path path
      And param postId = postId
      When method GET
      Then status 200
      And def commentsOfPost = response
      And print "Comments of post with ID " + postId + " : " , commentsOfPost
      And def fun =
      """
      function(responseArray){
      for (let i = 0; i < responseArray.length; i++){
          if(responseArray[i].postId != postId) return false
          else return true
      }
      }
      """
      And def checkPostIdInComments = fun(commentsOfPost)



