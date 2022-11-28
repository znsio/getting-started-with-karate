@eat @demo @prod @tags
Feature: tags api test

  @first
  Scenario: first api
    * print 'first api'

  @second @local @demo2
  Scenario: second api
    * print 'second api'
    * print 'system property foo in second api:', karate.properties['foo']

  @second @e2e
  Scenario: second e2e api
    * print 'second e2e api'

  @second @e2e
  Scenario Outline: second e2e flaky api
    * print "<number>: second e2e flaky api - instance <number>"
    * print "<number>: Java Random in feature: ", javaRandom(<number>)
    * print "<number>: Random number: ", generateRandomNumber(<number> * 10)
    * print "<number>: Time in ms: ", getCurrentTimeInMillis()
    * def JavaRandomizer = Java.type('com.znsio.common.JavaRandomizer')
    * def jr = new JavaRandomizer()
    * print "<number>: generateRandomAlphaNumericString: ", jr.generateRandomAlphaNumericString(<number> * 2)
    Examples:
    | number |
    |1       |
    |2       |
    |3       |
    |4       |
    |5       |
    |6       |
    |7       |
    |8       |
    |9       |
    |10       |

  @second @e2e
  Scenario Outline: third e2e flaky api
    * print '<number>: third e2e flaky api - instance <number>'
    * print "<number>: Java Random in feature: ", javaRandom(<number>)
    * print "<number>: Random number: ", generateRandomNumber(<number> * 10)
    * print "<number>: Time in ms: ", getCurrentTimeInMillis()
    * def JavaRandomizer = Java.type('com.znsio.common.JavaRandomizer')
    * def jr = new JavaRandomizer()
    * print "<number>: generateRandomAlphaNumericString: ", jr.generateRandomAlphaNumericString(<number> * 2)
    Examples:
    | number |
    |21       |
    |22       |
    |23       |
    |24       |
    |25       |
    |26       |
    |27       |
    |28       |
    |29       |
    |30       |

  @second @e2e @wip
  Scenario: second e2e api wip
    * print 'second e2e api wip'