@prod @restCountries
Feature: API tests for https://restcountries.com/

  Scenario: Get list of countries
    Given def listOfCountries = karate.call('classpath:com/znsio/templates/restCountryTemplates.feature@t_getCountries').countries
    Then print "listOfCountries: " + listOfCountries.length
    And assert listOfCountries.length > 200

