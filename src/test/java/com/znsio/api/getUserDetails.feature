@prod
Feature: Get user details

  @getPost
  Scenario Outline: Fetch all the posts for user with Id 1
    * def schema = read('classpath:com/znsio/templates/getPostApi.json');
    * def listOfPosts = karate.call('classpath:com/znsio/templates/jsonUserDetailsTemplate.feature@t_getPost', {userId: <userId>,"status": <status>}).listOfPosts
    * karate.log("List of all the post ",listOfPosts)
    * match  listOfPosts == <schema>

    Examples:
      |userId|status|schema                      |
      |1     |200   | schema.getPostSchema       |
      | 101  |404   | schema.getInvalidSchema    |
      | null |404   | schema.getInvalidSchema    |
      |&%$#@ |  400 | schema.getInvalidSchema    |
      |      | 404  | schema.getInvalidSchema    |

  @getAlbum
  Scenario Outline: Fetch all the albums for user Id 1
    * def schema = read('classpath:com/znsio/templates/getAlbumApi.json');
    * def listOfAlbums = karate.call('classpath:com/znsio/templates/jsonUserDetailsTemplate.feature@t_getAlbum', {userId:<userId>,"status": <status>}).listOfAlbums
    * karate.log("List of all the albums for user id  "+userId,listOfAlbums)
    * match each listOfAlbums[*] == <schema>
    * assert listOfAlbums.length >= 1

    Examples:
      |userId|status|schema                      |
      |1     |200   | schema.getAlbumSchema      |
      | 101  |404   | schema.getInvalidSchema    |
      | null |404   | schema.getInvalidSchema    |
      |&%$#@ | 404  | schema.getInvalidSchema    |
      |      | 404  |  schema.getInvalidSchema   |



            #Reffference
#  @jsonPlaceHolderComment
#  Scenario: Fetch all the comments for user with Id 1
#    * def userId = 1
#    * def listOfComments = karate.call('classpath:com/znsio/templates/jsonUserDetailsTemplate.feature@t_getComment', {userId:userId}).listOfComments
#    * karate.log("List of all the comments ", listOfComments)
#    * match listOfComments.id == userId
#    * match listOfComments.id == '#number'
#    * match listOfComments.name == '#string'
#    * match listOfComments.email == '#string'
#    * match listOfComments.body == '#string'

#    * match each listOfAlbums[*].userId == userId
#    * match each listOfAlbums[*].userId == '#number'
#    * match each listOfAlbums[*].id  == '#number'
#    * match each listOfAlbums[*].title  == '#string'


