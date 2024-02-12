@confengine @prod @wip
Feature: ConfEngine.com

  Scenario Outline: Find number of proposals in a conferences
    * def confUrl = "/conferences/<confName>/proposals"
    * print "Get number of proposals for conference: <confName> with path: " + confUrl
    * def proposalsInTheConferences = karate.call('classpath:com/znsio/templates/confEngineTemplates.feature@t_getProposalsForAConference', {'confUrl': confUrl, 'expectedStatus': <expectedStatus>}).proposals
    * print "proposalsInTheConferences: " + proposalsInTheConferences.length
    * def isInRange = isNumberBetween(proposalsInTheConferences.length, <min>, <max>)
    * match isInRange == true

    Examples:
      | confName             | min | max | expectedStatus |
      | functional-conf-2022 | 10  | 200 | 200            |
      | appium-conf-2021     | 10  | 200 | 200            |

  @confengineapi
  Scenario: Find number of conferences
    * print "Find number conferences"
    * def ids = call read('classpath:com/znsio/templates/confEngineTemplates.feature@t_getConferences')
    * def len =  ids.confIds.length
    * def isInRange = isNumberBetween(len, 100, 200)
    * match isInRange == true
