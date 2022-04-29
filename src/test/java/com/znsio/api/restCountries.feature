@prod @restCountries
Feature: API tests for https://restcountries.com/

  Scenario: Get list of countries
    * def listOfCountries = karate.call('classpath:com/znsio/templates/restCountryTemplates.feature@t_getCountries').countries
    * print "listOfCountries: " + listOfCountries.length
    * assert listOfCountries.length > 200

  Scenario Outline: Get list of states
    * def listOfCountries = karate.call('classpath:com/znsio/templates/restCountryTemplates.feature@t_getCountries').countries
    * print "listOfCountries: " + listOfCountries.length
    * assert listOfCountries.length > <expectedCount>

    Examples:
      | countryName | expectedCount |
      | India       | 200           |
      | Sri Lanka   | 200           |