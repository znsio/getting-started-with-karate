Feature: Common Utility Functions

  @generateRandomAlphaNumeric @template
  Scenario: Get random alphanumeric string
    * karate.log("Get random alphanumeric string of length: " + len)
    * def generateRandomAlphaNumeric =
    """
    function() {
    var Randomizer = Java.type('com.znsio.common.Randomizer');
    return new Randomizer().generateRandomAlphaNumericString(arguments[0]);
    }
    """
    * def generated = generateRandomAlphaNumeric(len)
    * karate.log("generateRandomAlphaNumeric: " + generated)

 @generateRandomNumberInRange @template
  Scenario: Generate random number in range
    * karate.log("Generate random number in range between: " + min + " and " + max)
    * def generateRandomNumberInRange =
    """
    function() {
    var Randomizer = Java.type('com.znsio.common.Randomizer');
    return new Randomizer().generateRandomNumberInRange(arguments[0], arguments[1]);
    }
    """
   * def generated = generateRandomNumberInRange(min, max)
   * print "generateRandomNumberInRange: " + generated

