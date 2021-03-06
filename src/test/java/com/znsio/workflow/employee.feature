@prod @getEmployees
Feature: Implementation for querying Employee APIs

  Scenario: Get list of all employees by calling Java function
    * print "Get list of all employees by calling Java function"

    Given def employeeId = karate.call('classpath:com/znsio/common/CommonFunctions.feature@generateRandomNumberInRange', {'min': 5, 'max': 50}).generated
    And print "employeeId generated by calling Java class: " + employeeId
    When print "Get employee details for employeeId: " + employeeId
    And call read('classpath:com/znsio/templates/employeeTemplates.feature@t_getEmployees') {'empId': #(employeeId) }
    Then print "response from getEmployees: " + response
    And match response.id == employeeId

  Scenario: Get list of all employees by calling common function
    * print "Get list of all employees by calling common function"

    Given def employeeId = randomNumberInRange(5,20)
    And print "employeeId generated by calling Java class: " + employeeId
    When print "Get employee details for employeeId: " + employeeId
    And call read('classpath:com/znsio/templates/employeeTemplates.feature@t_getEmployees') {'empId': #(employeeId) }
    Then print "response from getEmployees: " + response
    Then match response.id == employeeId