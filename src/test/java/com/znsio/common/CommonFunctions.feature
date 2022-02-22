Feature: Common Utility Functions

  @generateRandom @template
  Scenario: Get All Common Functions
    * def generateRandom =
    """
    function() {
    var GenerateMAC = Java.type('com.znsio.common.GenerateMAC');
    return new GenerateMAC().generateRandomAlphaNumericString(arguments[0]);
    }
    """
