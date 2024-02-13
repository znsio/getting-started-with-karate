@prod
Feature: Get user details
 Background:
   * def userid = 1

  @jsonPlaceHolder
  Scenario: Fetch all the posts
    * def userResponse = karate.call('classpath:com/znsio/templates/fetchingUserDetailsJsonPlaceHolder.feature@t_getPost', {userId:userid}).listOfPosts
    * print userResponse
    * match userResponse.id == userid
    * match userResponse.id == '#number'
    * match userResponse.title == '#string'
    * match userResponse.body == '#string'

  @jsonPlaceHolder
  Scenario: Fetch all the comments
    * def userResponse = karate.call('classpath:com/znsio/templates/fetchingUserDetailsJsonPlaceHolder.feature@t_getComment', {userId:userid}).listOfComments
    * print userResponse
    * match userResponse.id == userid
    * match userResponse.id == '#number'
    * match userResponse.name == '#string'
    * match userResponse.email == '#string'
    * match userResponse.body == '#string'



