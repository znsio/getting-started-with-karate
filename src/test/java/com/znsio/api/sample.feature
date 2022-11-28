@demo @demo @eat @prod @sample
Feature: sample api

  @demo2
  Scenario: first hello world api
    * print 'hello api'

    @flaky
  Scenario: second api
    * print 'second api'

  @second @e2e
  Scenario Outline: fourth e2e flaky api
    * print '<number>: fourth e2e flaky api - instance <number>'
    * print "<number>: Java Random in feature: ", javaRandom(<number>)
    * print "<number>: Random number: ", generateRandomNumber(<number> * 10)
    * print "<number>: Time in ms: ", getCurrentTimeInMillis()
    * def JavaRandomizer = Java.type('com.znsio.common.JavaRandomizer')
    * def jr = new JavaRandomizer()
    * print "<number>: generateRandomAlphaNumericString: ", jr.generateRandomAlphaNumericString(<number> * 2)
    Examples:
      | number |
      |31       |
      |32       |
      |33       |
      |34       |
      |35       |
      |36       |
      |37       |
      |38       |
      |39       |
      |40       |
