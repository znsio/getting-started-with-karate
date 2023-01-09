@template
Feature: Templates for ConfEngine

  Background:
    Given url env.confEngineUrl

  @t_getConferences
  Scenario: Get Conference Ids
    Given path '/conferences'
    * karate.log("Get all conference Ids")
    When method GET
    Then status 200
    * def listOfConferences = response
    * karate.log("Number of conferences found: " + listOfConferences.length)
    * def confIds = []
    * def getConfIds = function(x){ karate.appendTo(confIds, x.id) }
    * karate.forEach(listOfConferences, getConfIds)

  @t_getNumberOfProposalsInEachConference
  Scenario: Find Number of proposals in each conference
    * def confIds = get ids.confIds
    * karate.log("Get number of proposals for " + confIds.length + " conferences")
    * def conferenceUrls = []
    * def getConferenceUrl = function(x, i){ karate.appendTo(conferenceUrls, "/conferences/" + x + "/proposals") }
    * karate.forEach(confIds, getConferenceUrl)
    * karate.log("Number of conferences: " + conferenceUrls.length)
    * def proposalsInAllConferences = []
    * def getProposalsPerConference =
    """
    function(conferenceUrls){
      for (let index = 0; index < conferenceUrls.length; index++) {
        var confUrl = conferenceUrls[index];
        if (index < 10) {
          karate.log("Getting number of proposals for: " + confUrl + " at index: " + index);
          var response = karate.call('classpath:com/znsio/templates/confEngineTemplates.feature@t_getProposalsForAConference', {confUrl: confUrl, 'expectedStatus': 200}).proposals;
          karate.log("Number of proposals for: " + confUrl + " at index: " + index + ": " + response.length);
          karate.appendTo(proposalsInAllConferences, {'url': confUrl, 'numberOfProposals': response.length});
        }
      }
    }
    """
    * getProposalsPerConference(conferenceUrls)
    * karate.log("proposalsInAllConferences: " + proposalsInAllConferences.length)

  @t_getProposalsForAConference
  Scenario: Find list of proposals for a conference
    * karate.log("Get list of proposals for conference: " + confUrl)
    * karate.log("Expected status code: " + expectedStatus)
    Given path confUrl
    When method GET
    Then match responseStatus == expectedStatus
    * def proposals = response

