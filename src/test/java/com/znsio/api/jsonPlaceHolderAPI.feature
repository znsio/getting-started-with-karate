@jsonplaceholder @prod
Feature: JsonPlaceHolder API

  @posts
  Scenario: Get all the posts with specific userId
    * print "userId : " + jsonPlaceHolder.userId
    * def allPosts = karate.call('classpath:com/znsio/templates/placeHolderTemplates.feature@t_getPostByUserId', {'userId': jsonPlaceHolder.userId}).postsResponse
    * print "allPosts : " + allPosts
    * match allPosts == jsonPlaceHolder.expectedResponsePost

  @comments
  Scenario: Get all the comments with specific userId
    * print "userId : " + jsonPlaceHolder.userId
    * print "Find number of comments"
    * def allComments = karate.call('classpath:com/znsio/templates/placeHolderTemplates.feature@t_getCommentsByUserId', {'userId': jsonPlaceHolder.userId}).commentsResponse
    * print "allComments : " + allComments
    * def actualLength = allComments.length
    * match actualLength == jsonPlaceHolder.expectedResponseComment.length
    * match allComments contains jsonPlaceHolder.expectedResponseComment.data