@prod @getEmployees
Feature: Implementation for querying Employee APIs
@ignore
  Scenario: Get list of all employees by calling Java function
    * print "Get list of all employees by calling Java function"

    Given def employeeId = karate.call('classpath:com/znsio/common/CommonFunctions.feature@generateRandomNumberInRange', {'min': 5, 'max': 50}).generated
    And print "employeeId generated by calling Java class: " + employeeId
    When print "Get employee details for employeeId: " + employeeId
    And call read('classpath:com/znsio/templates/employeeTemplates.feature@t_getEmployees') {'empId': #(employeeId) }
    Then print "response from getEmployees: " + response
    And match response.id == employeeId
  @ignore
  Scenario: Get list of all employees by calling common function
    * print "Get list of all employees by calling common function"

    Given def employeeId = randomNumberInRange(5,20)
    And print "employeeId generated by calling Java class: " + employeeId
    When print "Get employee details for employeeId: " + employeeId
    And call read('classpath:com/znsio/templates/employeeTemplates.feature@t_getEmployees') {'empId': #(employeeId) }
    Then print "response from getEmployees: " + response
    Then match response.id == employeeId


    Scenario: Get the employees by calling common function
      Given print "Get the All the userid with userID_1 "
       * def pathResources = '/posts'

       * def allemployeePost = call read('classpath:com/znsio/templates/employeeTemplates.feature@t_getEmployees')
      And print allemployeePost
      * def post_UserIdWith1 = karate.call('classpath:com/znsio/common/Randomizer.feature' ,{'arr': allemployeePost,'key': "userId",'value': 1})
    Then print post_UserIdWith1


  Scenario: Get the employees by calling common function
    Given print "Get the All the albums with UserID_1 "
    * def pathResources = '/albums'
    * def allemployeeAlbum = call read('classpath:com/znsio/templates/employeeTemplates.feature@t_getAlbum')
    And print allemployeeAlbum
    * def album_UserIdWith1 = karate.call('classpath:com/znsio/common/Randomizer.feature' ,{'arr': allemployeeAlbum,'key': "userId",'value': 1})
    Then print album_UserIdWith1