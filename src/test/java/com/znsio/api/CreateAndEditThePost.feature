@createAndUpdatePost @prod
Feature: Create, update and validate the post

  Scenario: Create a post
    Given def createdPostResponse = karate.call('classpath:com/znsio/templates/CreateAndEditThePostTemplates.feature@t_createAPost',{"title": "foo","body": "bar","userId": 11}).createPost
    And assert createdPostResponse.id > 100
    And match createdPostResponse.id == '#number'
    And match createdPostResponse.userId == '#number'

  Scenario: Fetch a post and validate it
    Given def getCreatedPost = karate.call('classpath:com/znsio/templates/CreateAndEditThePostTemplates.feature@t_fetchAPost',{id:1}).fetchPost
    And match getCreatedPost.id == IdFetchedFromResponseOfCreatedPost
    And match getCreatedPost.userId == '#number'

  Scenario: Update a post title and verify the title
    Given def newUpdatedPostResponse  = karate.call('classpath:com/znsio/templates/CreateAndEditThePostTemplates.feature@t_updatePostTitle',{"id": 101,"title": "foo2","body": "bar","userId": 1}).updatePost
    And match newUpdatedPostResponse.title == 'foo2'
    And assert newUpdatedPostResponse.id > 100
    And match newUpdatedPostResponse.userId == '#number'

