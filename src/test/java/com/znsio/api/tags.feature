@eat @demo @prod
Feature: tags api test

  @first
  Scenario: first api
    * print 'first api'

  @second @local @demo2
  Scenario: second api
    * print 'second api'
    * print 'system property foo in second api:', karate.properties['foo']

  @second @e2e
  Scenario: second e2e api
    * print 'second e2e api'

  @second @e2e @wip
  Scenario: second e2e api wip
    * print 'second e2e api wip'