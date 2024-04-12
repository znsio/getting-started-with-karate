@prod @restCountries
Feature: API tests for https://restcountries.com/

  Background:
    Given def listOfCountries = read ('classpath:com/znsio/templates/restCountryTemplates.feature@t_getCountries')

  Scenario: Get list of countries
    Given def countriesResponse = call listOfCountries
    And json countries = countriesResponse.countries
    And print "listOfCountries: ", countries.length
    Then assert countries.length > 200
