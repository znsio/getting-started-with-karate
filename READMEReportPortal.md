# getting-started-with-karate
Sample project to get started with implementing and running karate tests, in a structured fashion.

Results are published in junit, html and cucumber-reporting format

# What is ReportPortal?

ReportPortal is a TestOps service, that provides increased capabilities to speed up results analysis and reporting through the use of built-in analytic features.

ReportPortal is a great addition to Continuous Integration and Continuous Testing process.

## Karate integration with ReportPortal?

To integrate the framework with ReportPortal, need to create a file named reportportal.properties in src/test/resources:

Example

        rp.endpoint={RP_SERVER_URL}
        rp.enable={true or flase}
        rp.project={YOUR_PROJECT}
        rp.launch={NAME_OF_YOUR_LAUNCH}

Property description

rp.endpoint - the URL for the report portal server (actual link).

rp.enable - signifies if report portal integeration is enabled or not. If true, then only the report will be shown on reportPortal.

rp.project - a project code on which the agent will report test launches. Must be set to one of your assigned projects.

rp.launch - a user-selected identifier of test launches.

## Show report portal URL in console:
Class SessionContext is added to show the report portal URL in console. In this class, reportportal.properties file is loaded and URL is created using endpoint, project name and launch id


## Use of Hooks
Karate provides a RunTimeHook and it implements hooks like

	· beforeSuite
	· beforeFeature
	· beforeScenario
	· beforeStep
	· afterStep
	· afterScenario
	· afterFeature
	· afterSuite

Class KarateReportPortalHook which implements and override interface RunTimeHook to integrate report portal with karate is called in RunTest class:

        .hook(newKarateReportPortalHook())

## Logging to ReportPortal

To make it easy to log to ReportPortal, the following new methods have been added:

```
        ReportPortalLogger.logDebugMessage("debugMessage");
        ReportPortalLogger.logInfoMessage("infoMessage");
        ReportPortalLogger.logWarningMessage("warningMessage");
        ReportPortalLogger.attachFileInReportPortal("message", new File("fileName"));
        ReportPortalLogger.logMessageWithLevel("message","logLevel");
```
## TODO:
Nested Implementation is yet to be completed.

As of now nested steps are showing up on report portal but not completely in a way in which it should have been. Below are the current issue or points need to implemented:
*     Failed steps are showing up as PASSED
*     After the failed step, further steps are not showing up on report portal

Need to add code to Log all Background steps inside a "Background " keyword
Need to find a way to log status of a Step using step Annotation (Currently all steps are getting marked as PASSED by default)

