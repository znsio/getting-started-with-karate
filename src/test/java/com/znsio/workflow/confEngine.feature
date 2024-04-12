@confengine @prod @wip
Feature: ConfEngine.com

  Scenario: Find number of proposals in all the conferences
    And print "Find number of proposals in all the conferences"
    * def ids = call read('classpath:com/znsio/templates/confEngineTemplates.feature@t_getConferences')
    * def len =  ids.confIds.length
    * def isInRange = isNumberBetween(len, 100, 200)
    * match isInRange == true
    * def proposalsInTheConferences = karate.call('classpath:com/znsio/templates/confEngineTemplates.feature@t_getNumberOfProposalsInEachConference').proposalsInAllConferences
    And print "proposalsInTheConferences: " + proposalsInTheConferences.length
    * match each proposalsInTheConferences == { numberOfProposals: '#number', url: '#string' }
    * match each proposalsInTheConferences contains { numberOfProposals: '#number' }
    * match each proposalsInTheConferences contains { numberOfProposals: '#? _ > 0 && _ < 400' }

