@createAndUpdatePost @prod
Feature: Create, update and validate the post

  Scenario: Create and fetch the post and validate it
    Given def createdPostResponse = call read('classpath:com/znsio/templates/CreateAndEditThePostTemplates.feature@t_createAPost') {"title": "foo","body": "bar","userId": 11}
    * def createdPost = createdPostResponse.createPost
    And assert createdPost.id > 100
    And match createdPost.id == '#number'
    And match createdPost.userId == '#number'
    * def IdFetchedFromResponseOfCreatedPost = createdPost.id

    Given def getCreatedPost = karate.call('classpath:com/znsio/templates/CreateAndEditThePostTemplates.feature@t_fetchAPost').fetchPost
    And match getCreatedPost.id == IdFetchedFromResponseOfCreatedPost
    And match getCreatedPost.userId == '#number'

  Scenario: Update a post title and verify the title
    Given def newUpdatedPostResponse  = call read('classpath:com/znsio/templates/CreateAndEditThePostTemplates.feature@t_updatePostTitle') {"id": 101,"title": "foo2","body": "bar","userId": 1}
    * def newUpdatedPost = newUpdatedPostResponse.updatePost
    And match newUpdatedPost.title == 'foo2'
    And assert newUpdatedPost.id > 100
    And match newUpdatedPost.userId == '#number'

