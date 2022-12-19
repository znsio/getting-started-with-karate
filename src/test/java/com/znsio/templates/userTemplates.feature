@usertemplate
  Feature: Template for JsonPlaceHolder api

  Background:
    * print "jsonPlaceHolder url " + env.jsonPlaceholderUrl
    Given url env.jsonPlaceholderUrl

    @t_getUserPosts
    Scenario: Get all the posts for a given user
      * def query = {userId:'(user_Id)'}
      Given path '/posts/'
      And params query
      When method GET
      Then status 200

    @t_getUserAlbums
    Scenario: Get albums for a given user
      Given path '/users/' + user_Id + '/albums'
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
      Given path '/posts'
      And request payload
      When method PATCH
      Then status 200