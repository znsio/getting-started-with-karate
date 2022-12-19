@prod @CreateUpdate

  # TARGET_ENVIRONMENT=prod TYPE=workflow TAG=@CreateUpdate ./gradlew test
Feature: Create update and validate

  @createPost
  Scenario: Create and validate post
    * def title = generateAlphaNumericRandomString(5)
    * def body = generateAlphaNumericRandomString(10)
    * def userId = generateRandomNumber(2)
    * karate.log('Creating random title -' ,title + '  body -',body + '  userId -' ,userId)
    Given def createPostResponse = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_createPost',{"title": title,"body": body,"userId": userId, "status": 201}).response
    And print createPostResponse
    * match createPostResponse.title == title
    * match createPostResponse.body == body
    * match createPostResponse.userId == userId
    And assert createPostResponse.id > 100
    * def newTitle = generateAlphaNumericRandomString(5)
    And def updateResponse = karate.call('classpath:com/znsio/templates/jsonPlaceHolderTemplates.feature@t_updateTitle',{"title": newTitle,"body": body,"userId": userId, "status": 200}).response
    * match updateResponse.title == newTitle