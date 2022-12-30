@template
Feature: API templates to perform CRUD operations on posts and albums of a user

  Background:
    Given url env.fetchPostsAndAlbumsUrl

  @t_getUserPosts
  Scenario: Fetch all the posts for a user with given user id
    Given path "/posts"
    And karate.log("fetchPostsAndAlbumsUrl: " + env.fetchPostsAndAlbumsUrl + "/posts")
    And param userId = userId
    When method GET
    Then status 200
    * def data = response

  @t_getSinglePost
  Scenario: Fetch all the posts for a user with given user id
    Given path "/posts/" + id
    And karate.log("fetchPostsAndAlbumsUrl: " + env.fetchPostsAndAlbumsUrl + "/posts/" + id)
    When method GET
    Then status 200
    * def data = response

  @t_getUserAlbums
  Scenario: Fetch all the albums for a user with given user id
    Given path "/albums"
    And karate.log("fetchPostsAndAlbumsUrl: " + env.fetchPostsAndAlbumsUrl + "/albums")
    And param userId = userId
    When method GET
    Then status 200
    * def data = response

  @t_createUserPost
  Scenario: Create a post for a user
    Given path "/posts"
    And karate.log("fetchPostsAndAlbumsUrl: " + env.fetchPostsAndAlbumsUrl + "/posts")
    And headers {Content-type: 'application/json; charset=UTF-8'}
    And request request
    When method POST
    Then status 201
    * def data = response

  @t_updateUserPost
  Scenario: Update Post for a user
    Given path '/posts/'+id
    And request request
    And header Content-Type = 'application/json'
    When method PATCH
    Then status 200



