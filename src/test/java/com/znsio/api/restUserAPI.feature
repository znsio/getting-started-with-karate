@userPost @prod
Feature: Fetch posts and comments
  Background:
    * def userId = 1
    * def postId = 1

  @getPosts
  Scenario: Get posts with specific User id
    Given def getPostsResponse = karate.call('classpath:com/znsio/templates/restUserTemplates.feature@t_getUserPosts', {'user_Id': userId})
    And match each getPostsResponse[*].userId == userId
    Then print getPostsResponse
     * def expectedSchema =
    """
     {
      "userId": #number,
      "id": #number,
      "title": #string,
      "body": #string
    }
    """
    And match getPostsResponse.response[0] == expectedSchema

  @getComments
  Scenario: Get comment with specific User id
    Given def getCommentsResponse = karate.call('classpath:com/znsio/templates/restUserTemplates.feature@t_getUserComments', {'postId': postId})
    And match each getCommentsResponse[*].postId == postId
    Then print getCommentsResponse
    * def expectedSchema =
    """
    {
      "postId": #number,
      "id": #number,
      "name": #string,
      "email": #string,
      "body": #string
    }
    """
    And match getCommentsResponse.response[0] == expectedSchema
