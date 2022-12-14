@FetchUserPostsAndComments @prod
Feature: Fetch users posts and comments

  Background: passing id
    * def userWithId = 1

  Scenario: Fetch all the posts for a user using id
    Given def fetchPosts = karate.call('classpath:com/znsio/templates/FetchUserPostsAndCommentsTemplates.feature@t_getPostsById').userPost
    And match fetchPosts.id == userWithId
    And match fetchPosts.userId == '#number'

  Scenario: Fetch all the comments for a user using  id
    Given def fetchComments = karate.call('classpath:com/znsio/templates/FetchUserPostsAndCommentsTemplates.feature@t_getCommentsById').userComment
    And match fetchComments.id == userWithId
    And match fetchComments.postId == '#number'
