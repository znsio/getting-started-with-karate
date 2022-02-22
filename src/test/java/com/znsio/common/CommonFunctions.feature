Feature: Common Utility Functions

  @generateRandom @template
  Scenario: Get All Common Functions
    * def generateRandom =
    """
    function() {
    var SampleJava = Java.type('com.znsio.common.SampleJava');
    return new SampleJava().generateRandomAlphaNumericString(arguments[0]);
    }
    """
