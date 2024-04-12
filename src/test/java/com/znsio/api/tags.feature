@eat @demo @prod @tags
Feature: tags api test

  @first
  Scenario: first api
    And print 'first api'

  @second @local @demo2
  Scenario: second api
    And print 'second api'
    And print 'system property foo in second api:', karate.properties['foo']

  @second @e2e
  Scenario: second e2e api
    And print 'second e2e api'

  @second @e2e @wip
  Scenario: second e2e api wip
    And print 'second e2e api wip'
