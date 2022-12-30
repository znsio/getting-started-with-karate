@template
Feature: API templates to perform CRUD operations on posts and albums of a user

  Background:
    Given url env.fetchPostsAndAlbumsUrl

  @t_getUserPosts
  Scenario: Fetch all the posts for a user with given user id
    Given path "/posts"
    And karate.log("fetchPostsAndAlbumsUrl: " + env.fetchPostsAndAlbumsUrl + "/posts")
    * param userId = userId
    * method GET
    * status 200
    * def data = response

  @t_getSinglePost
  Scenario: Fetch all the posts for a user with given user id
    Given path "/posts/" + id
    And karate.log("fetchPostsAndAlbumsUrl: " + env.fetchPostsAndAlbumsUrl + "/posts/" + id)
    * method GET
    * status 200
    * def data = response

  @t_getUserAlbums
  Scenario: Fetch all the albums for a user with given user id
    Given path "/albums"
    And karate.log("fetchPostsAndAlbumsUrl: " + env.fetchPostsAndAlbumsUrl + "/albums")
    * param userId = userId
    * method GET
    * status 200
    * def data = response

  @t_createUserPost
  Scenario: Create a post for a user
    Given path "/posts"
    And karate.log("fetchPostsAndAlbumsUrl: " + env.fetchPostsAndAlbumsUrl + "/posts")
    * headers {Content-type: 'application/json; charset=UTF-8'}
    * request request
    * method POST
    * status 201
    * def data = response

  @t_updateUserPost
  Scenario : Update a post for a user
    Given path "/posts/" + id
    And karate.log("fetchPostsAndAlbumsUrl: " + env.fetchPostsAndAlbumsUrl + "/posts/" + id)
    * headers {Content-type: 'application/json; charset=UTF-8'}
    * request {title : request}
    * method PATCH
    * status 200
    * def data = response


