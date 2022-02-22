Feature: Implementation for querying Employee APIs

  @getEmployees
  @prod
  Scenario: Get list of all employees
    * print "Get list of all employees"
#    * def generateRandom =
#    """
#    function() {
#    var GenerateMAC = Java.type('com.znsio.common.GenerateMAC');
#    return new GenerateMAC().generateRandomAlphaNumericString(arguments[0]);
#    }
#    """
    * call read('classpath:com/znsio/common/CommonFunctions.feature@generateRandom')
    * def val = generateRandom(20)
    * print val
    * call read('classpath:com/znsio/templates/Employees.feature@t_getEmployees')