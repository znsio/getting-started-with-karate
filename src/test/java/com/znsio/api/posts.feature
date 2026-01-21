@prod @posts
  Feature: API test for https://jsonplaceholder.typicode.com

    Scenario: Get posts of user
      Given def userId = 1
      And def checkUserIdInPosts = karate.call('classpath:com/znsio/templates/postsTemplates.feature@getPostsOfUser', {'userId' : userId}).checkUserIdInPosts
      Then assert checkUserIdInPosts == true

    Scenario: Get comments of user
      Given def postId = 1
      And def checkPostIdInComments = karate.call('classpath:com/znsio/templates/postsTemplates.feature@getCommentsOfPost', {'postId' : postId}).checkPostIdInComments
      Then assert checkPostIdInComments == true

