@prod
Feature: Edit the post
  * def status = 200;

  @createPost
  Scenario: Edit the post by creating it
    * def input = read('classpath:com/znsio/templates/createPostApi.json');
    * def createDetails = input.createRequest
    Given def postedDetails = karate.call('classpath:com/znsio/templates/jsonUserDetailsTemplate.feature@t_CreatePost', {input : createDetails}).post
    * karate.log("Details of created post ",postedDetails)
    * match postedDetails.title == createDetails.title
    * match postedDetails.body == createDetails.body
    * match postedDetails.userId == createDetails.userId
    * def id = postedDetails.id
    * karate.log( "Generated id is ", id)

    * def postSchemaGet = read('classpath:com/znsio/templates/getPostApi.json');
    Given def getDetailsCreated = karate.call('classpath:com/znsio/templates/jsonUserDetailsTemplate.feature@t_getPost', {userId:id}).listOfPosts
    * karate.log("List of all the post created ",getDetailsCreated)
    * match getDetailsCreated.id == id
    * match  getDetailsCreated == postSchemaGet.getPostSchema

    * def updateDetails = read('classpath:com/znsio/templates/updatePostApi.json');
    * def updateRequest = updateDetails.updateRequest
    Given def updatedDetails = karate.call('classpath:com/znsio/templates/jsonUserDetailsTemplate.feature@t_EditPost', {input : updateRequest, id : id}).edit
    * karate.log("User post details after edit ", updatedDetails)
    * match updatedDetails.title == updateRequest.title
    * match updatedDetails.body == updateRequest.body
    * match updatedDetails == updateDetails.updateResponseSchema
    * match updatedDetails.id == id

    Given def getDetailsEdited = karate.call('classpath:com/znsio/templates/jsonUserDetailsTemplate.feature@t_getPost', {userId:id}).listOfPosts
    * karate.log("List of all the post ",getDetails)
    * match getDetailsEdited.id == id
    * match  getDetailsEdited == postSchemaGet.getPostSchema

    # add get details after create action