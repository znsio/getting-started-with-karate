@template
Feature: API tests for https://jsonplaceholder.typicode.com/

  Background:
    Given url env.fetchPostsAndAlbumsUrl
    And print "fetchPostsAndAlbumsUrl: " + env.fetchPostsAndAlbumsUrl

  @t_getPosts
  Scenario: Get list of posts for userId 1
    Given def path = "/posts"
    * def queryParam = {userId : '1'}
    And print "Get list of Posts from " + env.fetchPostsAndAlbumsUrl + path
    And path path
    And params queryParam
    When method GET
    Then status 200
    And print response.length
    And def posts = response
    * print "Response from /posts: ", response

#    Examples:
#    |param|value|
#    |'userId'|'1 '  |

  @t_getAlbums
  Scenario: Get list of albums for userId 1
    Given def path = "/albums"
    * def queryParam = {userId : '1'}
    And print "Get list of Albums from " + env.fetchPostsAndAlbumsUrl + path
    And path path
    And params queryParam
    When method GET
    Then status 200
    And print response.length
    And def posts = response
    * print "Response from /albums: ", response