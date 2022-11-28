@prod @restCountries
Feature: API tests for https://restcountries.com/

  Scenario: Get list of countries
    Given def listOfCountries = karate.call('classpath:com/znsio/templates/restCountryTemplates.feature@t_getCountries').countries
    Then print "listOfCountries: " + listOfCountries.length
    And assert listOfCountries.length > 200

  @second @e2e
  Scenario: restCountries e2e api
    * print 'restCountries e2e api'

  @second @e2e @flaky
  Scenario: restCountries flaky e2e api
    * print 'restCountries flaky e2e api'