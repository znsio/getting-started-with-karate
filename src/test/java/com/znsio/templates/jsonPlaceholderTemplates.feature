@template
Feature: API template to fetch posts and albums of a user

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

  @t_getUserAlbums
  Scenario: Fetch all the albums for a user with given user id
    Given path "/albums"
    And karate.log("fetchPostsAndAlbumsUrl: " + env.fetchPostsAndAlbumsUrl + "/albums")
    * param userId = userId
    * method GET
    * status 200
    * def data = response
