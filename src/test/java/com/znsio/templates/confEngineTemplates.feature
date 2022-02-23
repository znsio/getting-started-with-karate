@template
Feature: Templates for ConfEngine

  Background:
    Given url 'https://confengine.com/api/v3'

  @t_getConferences
  Scenario: Get Conference Ids
    Given path '/conferences'
    * print "Get all conference Ids"
    When method GET
    Then status 200
    * def listOfConferences = response
    * print "Number of conferences found: " + listOfConferences.length
    * def confIds = []
    * def getConfIds = function(x){ karate.appendTo(confIds, x.id) }
    * karate.forEach(listOfConferences, getConfIds)

  @t_getNumberOfProposalsInEachConference
  Scenario: Find Number of proposals in each conference
    * def confIds = get ids.confIds
    * print "Get number of proposals for " + confIds.length + " conferences"
    * def conferenceUrls = []
    * def getConferenceUrl = function(x, i){ karate.appendTo(conferenceUrls, "/conferences/" + x + "/proposals") }
    * karate.forEach(confIds, getConferenceUrl)
    * print "Number of conferences: " + conferenceUrls.length

    * def proposalsInAllConferences = []
    * def getProposalsPerConference =
    """
    function(conferenceUrls){
      for (let index = 0; index < conferenceUrls.length; index++) {
        var confUrl = conferenceUrls[index];
        if (index < 3) {
          karate.log("Getting number of proposals for: " + confUrl + " at index: " + index);
          var response = karate.call('classpath:com/znsio/templates/confEngineTemplates.feature@t_getProposalsForAConference', {confUrl: confUrl}).proposals;
          karate.log("Number of proposals for: " + confUrl + " at index: " + index + ": " + response.length);
          karate.appendTo(proposalsInAllConferences, {'url': confUrl, 'numberOfProposals': response.length});
        }
      }
    }
    """
    * getProposalsPerConference(conferenceUrls)
    * print "proposalsInAllConferences: " + proposalsInAllConferences.length

  @t_getProposalsForAConference
  Scenario: Find list of proposals for a conference
    * print "Get list of proposals for conference: " + confUrl
    Given path confUrl
    When method GET
    Then status 200
    * def proposals = response

