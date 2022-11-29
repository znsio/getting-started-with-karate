@FetchAndPostCommentForUserId1 @prod
Feature: Fetch users posts and their comments

  Background: passing id
    * def Id = 1

  Scenario: Fetch all the posts for a user with id 1
    Given def listOfPosts = karate.call('classpath:com/znsio/templates/FetchUserPostsAndCommentsTemplates.feature@t_getPostsById').userPost
    And match listOfPosts.id == Id

  Scenario: Fetch all the comments for a user with id 1
    Given def listOfComments = karate.call('classpath:com/znsio/templates/FetchUserPostsAndCommentsTemplates.feature@t_getCommentsById').userComment
    And match listOfComments.id == Id
