@prod
Feature: Edit the post

  Background:
    * def input = read('classpath:com/znsio/userDetails.json');

  @createPost
  Scenario: Edit the post by creating it
    * def createDetails = input.create
    Given def postedDetails = karate.call('classpath:com/znsio/templates/jsonUserDetailsTemplate.feature@t_CreatePost', {input : createDetails}).post
    * karate.log("Details of created post ",postedDetails)
    * match postedDetails.title == createDetails.title
    * match postedDetails.body == createDetails.body
    * match postedDetails.userId == createDetails.userId
    * def id = postedDetails.id
    * karate.log( "Generated id is ", id)
    * def updateDetails = input.update
    Given def updatedDetails = karate.call('classpath:com/znsio/templates/jsonUserDetailsTemplate.feature@t_EditPost', {input : updateDetails,id : id}).edit
    * karate.log("User post details after edit ", updatedDetails)
    * match updatedDetails.title == updateDetails.title
    * match updatedDetails.body == updateDetails.body
    * match updatedDetails == input.editedPostSchema
    * match updatedDetails.id == id
    Given def getDetails = karate.call('classpath:com/znsio/templates/jsonUserDetailsTemplate.feature@t_getPost', {userId:id}).listOfPosts
    * karate.log("List of all the post ",getDetails)
    * match getDetails.id == userId
    * match  getDetails == schema.getPostSchema

