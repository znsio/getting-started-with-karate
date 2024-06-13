@template
Feature: Template for JSONPlaceHolder api

  Background:
    Given url env.jsonPlaceholderUrl

    @t_getUserPosts
    Scenario: Get posts for a given user id
      * def query = {userId:'#(user_Id)'}
      Given path '/posts'
      And params query
      When method GET
      Then status 200

     @t_getUserAlbums
     Scenario: Get comments for a giver post id
       Given path '/users/'+ user_Id + '/albums'
       When method GET
       Then status 200

    @t_createPost
    Scenario: Create a post
      Given path '/posts'
      And request payload
      When method POST
      Then status 201

    @t_updatePost
    Scenario: Update a post
      Given path '/posts/' + Id
      And request payload
      When method PATCH
      Then status 200