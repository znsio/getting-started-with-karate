@template
Feature: Template for rest user

  Background:
    Given url env.jsonPlaceholderUrl

    @t_getUserPosts
    Scenario: Get posts for a given user id
      * def query = {userId:'#(user_Id)'}
      Given path '/posts'
      And params query
      When method GET
      Then status 200

     @t_getUserComments
     Scenario: Get comments for a giver post id
       Given path '/posts/'+ postId + '/comments'
       When method GET
       Then status 200