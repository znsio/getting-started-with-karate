@confengine @prod
Feature: ConfEngine.com

  Scenario: Find number of proposals in all the conferences
    * print "Find number of proposals in all the conferences"
    * def ids = call read('classpath:com/znsio/templates/confEngineTemplates.feature@t_getConferences')
    * def len =  ids.confIds.length
    * def isInRange = isNumberInRange(len, 100, 200)
    * match isInRange == true
    * def proposalsInTheFirstConference = karate.call('classpath:com/znsio/templates/confEngineTemplates.feature@t_getNumberOfProposalsInEachConference').proposalsInAllConferences
    * print "1 proposalsInTheFirstConference: " + proposalsInTheFirstConference.length
    * print "3 proposalsInTheFirstConference: " + proposalsInTheFirstConference[0].url
    * match each proposalsInTheFirstConference == { numberOfProposals: '#number', url: '#string' }
    * match each proposalsInTheFirstConference contains { numberOfProposals: '#number' }
    * match each proposalsInTheFirstConference contains { numberOfProposals: '#? _ > 25 && _ < 200' }

