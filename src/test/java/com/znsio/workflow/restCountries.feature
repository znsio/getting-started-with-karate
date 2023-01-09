@prod @restCountries
Feature: API Workflow tests for Rest Countries

  Scenario Outline: Get list of states
    Given json countryDetails = karate.call('classpath:com/znsio/templates/restCountryTemplates.feature@t_getCountryDetails', { 'countryName': '<countryName>' })
    And def populationOfCountry = countryDetails.response[0].population
    And karate.log("populationOfCountry: ", populationOfCountry)
    When def capitalCity = countryDetails.response[0].capital[0]
    And karate.log("Capital of <countryName> is:", capitalCity)
    And json capitalDetails = karate.call('classpath:com/znsio/templates/restCountryTemplates.feature@t_getCountryCapitalDetails', { 'capitalName': capitalCity })
    Then def populationFromCapital = capitalDetails.response[0].population
    And karate.log("populationFromCapital: ", populationFromCapital)
    And assert populationFromCapital == populationOfCountry

    Examples:
      | countryName |
      | India       |
      | Sri Lanka   |