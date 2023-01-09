@prod @restCountries
Feature: API tests for Rest Countries

  Scenario: Get list of countries
    Given def listOfCountries = karate.call('classpath:com/znsio/templates/restCountryTemplates.feature@t_getCountries').countries
    Then karate.log("listOfCountries: " + listOfCountries.length)
    And assert listOfCountries.length > 200

