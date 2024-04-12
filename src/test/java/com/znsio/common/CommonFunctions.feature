@template
Feature: Common Utility Functions

  @generateRandomAlphaNumeric
  Scenario: Get random alphanumeric string
    And print "Get random alphanumeric string of length: ", len
    * def generateRandomAlphaNumeric =
    """
    function() {
    var Randomizer = Java.type('com.znsio.common.Randomizer');
    return new Randomizer().generateRandomAlphaNumericString(arguments[0]);
    }
    """
    * def generated = generateRandomAlphaNumeric(len)
    And print "generateRandomAlphaNumeric: ", generated

 @generateRandomNumberInRange
  Scenario: Generate random number in range
    And print "Generate random number in range using CommonFunctions.feature's generateRandomNumberInRange function between: " + min + " and " + max
    * def generateRandomNumberInRange =
    """
    function() {
    var Randomizer = Java.type('com.znsio.common.Randomizer');
    return new Randomizer().generateRandomNumberInRange(arguments[0], arguments[1]);
    }
    """
   * def generated = generateRandomNumberInRange(min, max)
   And print "generateRandomNumberInRange: ", generated
