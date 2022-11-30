@sampleApi @prod
Feature: Create and edit post

  Background: API url

  Scenario: Create a post and fetch the created post
    Given def createdPost = karate.call('classpath:com/znsio/templates/CreateAndEditThePostTemplates.feature@t_createAPost').createPost
    And assert createdPost.id > 100
    And match createdPost.id == '#number'
    And match createdPost.userId == '#number'
    * def Id = createdPost.id

    Given def listOfPosts = karate.call('classpath:com/znsio/templates/CreateAndEditThePostTemplates.feature@t_fetchAPost').fetchPost
    And match listOfPosts.id == Id
    And match listOfPosts.userId == '#number'

   Scenario: Update the created post title and verify the title
    Given def newUpdatedPost = karate.call('classpath:com/znsio/templates/CreateAndEditThePostTemplates.feature@t_updatePostTitle').updatePost
    And match newUpdatedPost.title == 'foo2'
    And assert newUpdatedPost.id > 100
    And match newUpdatedPost.userId == '#number'

