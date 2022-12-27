@prod @posts
Feature: Getting all the posts and albums with UserID specfication

  Background:
    * def query = {userId:'1'}
    * def expectedresult = read('posts_albums_response.json')


  Scenario: Get all the posts of employees with UserID 1
    And def pathResources = '/posts'
    When  def allemployeePost = call read('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getPostsEmployees')
     And karate.log (allemployeePost)
    Then match allemployeePost.response[*].userId contains [1]
    And match allemployeePost.response == expectedresult[0]



  Scenario: Get all the albums of employees with UserID 1

    And def pathResources = '/albums'
    When def allemployeeAlbum = call read('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_getAlbumsEmployees')
    And karate.log(allemployeeAlbum)
    Then match allemployeeAlbum.response[*].userId contains [1]
    And  match allemployeeAlbum.response == expectedresult[1]