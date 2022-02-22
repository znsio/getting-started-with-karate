Feature: Implementation for querying Employee APIs

  @getEmployees
  @prod
  Scenario: Get list of all employees
    * print "Get list of all employees"
    * call read('classpath:com/znsio/common/CommonFunctions.feature@generateRandom')
    * def val = generateRandom(20)
    * print val
    * call read('classpath:com/znsio/templates/Employees.feature@t_getEmployees')