@prod
Feature: sample workflow

  @eat @first
  Scenario: first workflow
    * print 'first workflow'

  @local @second
  Scenario: second workflow
    * print 'second workflow'

  @eat @wip
  Scenario: second workflow wip
    * print 'second workflow wip'