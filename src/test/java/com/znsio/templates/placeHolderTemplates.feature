@template
Feature: Templates for jsonPlaceHolder

  Background:
    * url env.jsonPlaceHolderUrl
    * def testData = read('classpath:' + karate.info.featureDir.split('test/')[1] + '/templateData/' + karate.info.featureFileName.split('.')[0] + '_testData.json')
    * def userId = typeof userId === 'undefined' ? 1 : userId

  @t_getPostByUserId
  Scenario: Get all the posts with specific userId
    * print "userId", userId
    * path 'posts/' + userId
    * print "Get all posts with userId as " + userId
    * method GET
    * print "Posts found: ", response

  @t_getCommentsByUserId
  Scenario: Get all the comments with specific userId
    Given path 'comments'
    And param id = userId
    When method GET
    * print "Number of comments found: " + response.length
    * print "comments found: ", response
