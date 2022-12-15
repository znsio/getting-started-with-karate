@prod @jsonplaceholder
Feature: JSON Placeholder API

  Background: passing id
    * def userWithId = 1

  Scenario: Get all posts with specific userId
    Given def userPosts = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@getPostsById',{"userWithId": userWithId})
    And print userPosts.response
    Then assert userPosts.response.id == userWithId


    Scenario: Get all comments with specific userId
      Given def userComments = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@getCommentsById',{"userWithId": userWithId})
      And print userComments.response
      Then match each userComments.response[*].postId == userWithId