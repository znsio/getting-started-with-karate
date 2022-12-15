@template
Feature: Template for fetch user posts and comments

  Background:
    * url env.jsonPlaceHolderUrl

  @getPostsById
  Scenario: Fetch posts for user with id
    * path 'posts/' + userWithId
    * method GET
    * status 200
    * print 'posts from user with id' + userWithId + response


  @getCommentsById
  Scenario: Fetch comments for user with id
    * path 'comments'
    * param postId = userWithId
    * method GET
    * status 200
    * print 'comments from user with id' + userWithId + response