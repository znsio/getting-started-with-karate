@eat @demo @prod @tags @hardGate
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

  @second @e2e @wip @failing
  Scenario: second e2e api failing wip
    And print 'second e2e api wip'

  @second @e2e @failing
  Scenario: second e2e api failing
    And print 'second e2e api failing'
    And match 1 == 2

  @second @e2e @failing
  Scenario: second e2e api failing skip
    And print 'second e2e api failing skip'
    And match 1 == 2
    And print 'second e2e api failing skip'

  @second @e2e @failing
  Scenario Outline: second e2e api failing skip
    And print 'second e2e api failing skip'
    And match <num1> == <num2>
    And print 'second e2e api failing skip'
    Examples:
    | num1 | num2 |
    | 1    | 2    |
    | 3    | 4    |

  @second @e2e
  Scenario Outline: second e2e api passing skip
    And print 'second e2e api passing skip'
    And match <num1> == <num2>
    And print 'second e2e api passing skip'
    Examples:
    | num1 | num2 |
    | 1    | 1    |
    | 2    | 2    |
    | 3    | 3    |
