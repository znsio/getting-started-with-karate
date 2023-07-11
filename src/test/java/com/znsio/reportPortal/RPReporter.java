package com.znsio.reportPortal;

import com.epam.reportportal.listeners.ListenerParameters;
import com.epam.reportportal.service.Launch;
import com.epam.reportportal.service.ReportPortal;
import com.epam.ta.reportportal.ws.model.FinishExecutionRQ;
import com.epam.ta.reportportal.ws.model.FinishTestItemRQ;
import com.epam.ta.reportportal.ws.model.StartTestItemRQ;
import com.epam.ta.reportportal.ws.model.attribute.ItemAttributesRQ;
import com.epam.ta.reportportal.ws.model.launch.StartLaunchRQ;
import com.epam.ta.reportportal.ws.model.log.SaveLogRQ;
import com.google.common.base.Strings;
import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;
import com.intuit.karate.Suite;
import com.intuit.karate.core.*;
import io.reactivex.Maybe;
import org.apache.log4j.Logger;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.google.common.base.Strings.isNullOrEmpty;

class RPReporter {
    private final Map<String, Date> featureStartDate = Collections.synchronizedMap(new HashMap<String, Date>());
    private static final Logger LOGGER = Logger.getLogger(RPReporter.class.getName());
    private Supplier<Launch> launch;

    RPReporter() {
    }

    void startLaunch() {
        this.launch = Suppliers.memoize(new Supplier<Launch>() {
            private final Date startTime = getTime();

            @Override
            public Launch get() {
                final ReportPortal reportPortal = ReportPortal.builder().build();
                ListenerParameters parameters = reportPortal.getParameters();
                StartLaunchRQ startLaunchRq = new StartLaunchRQ();
                startLaunchRq.setName(parameters.getLaunchName());
                startLaunchRq.setStartTime(startTime);
                startLaunchRq.setMode(parameters.getLaunchRunningMode());
                startLaunchRq.setAttributes(parameters.getAttributes());
                if (!isNullOrEmpty(parameters.getDescription())) {
                    startLaunchRq.setDescription(parameters.getDescription());
                }
                startLaunchRq.setRerun(parameters.isRerun());
                if (!isNullOrEmpty(parameters.getRerunOf())) {
                    startLaunchRq.setRerunOf(parameters.getRerunOf());
                }
                return reportPortal.newLaunch(startLaunchRq);
            }
        });
        this.launch.get().start();
    }

    void finishLaunch(Suite suite) {
        FinishExecutionRQ finishLaunchRq = new FinishExecutionRQ();
        finishLaunchRq.setEndTime(getTime());
        finishLaunchRq.setStatus(getLaunchStatus(suite));

        launch.get().finish(finishLaunchRq);
    }

    synchronized boolean isTemplate(Feature feature) {
        if (feature != null) {
            List<Tag> featureTags = feature.getTags();
            if (featureTags != null && !featureTags.isEmpty()) {
                for (Tag tag : featureTags) {
                    if (tag.getName().equalsIgnoreCase("template")) return true;
                }
            }
        }
        return false;
    }

    synchronized boolean isTemplate(Scenario scenario) {
        if (scenario != null) {
            List<Tag> scenarioTags = scenario.getTags();
            if (scenarioTags != null && !scenarioTags.isEmpty()) {
                for (Tag tag : scenarioTags) {
                    if (tag.getName().equalsIgnoreCase("template")) return true;
                }
            }
        }
        return false  ;
    }

    synchronized void startFeature(Feature feature) {
        featureStartDate.put(getUri(feature), getTime());
    }

    synchronized void finishFeature(FeatureResult featureResult) {

        StartTestItemRQ startFeatureRq = this.setFeatureDetailsInReportPortal(featureResult);
        Maybe<String> featureId = launch.get().startTestItem(null, startFeatureRq);
        //launches feature to report portal and logs it

        for (ScenarioResult scenarioResult : featureResult.getScenarioResults()) {
            //for multiple scenarios inside a features it will log each scenario inside the feature
            this.setScenarioDetailsInReportPortal(scenarioResult,featureResult,featureId);
        }

        FinishTestItemRQ finishFeatureRq = new FinishTestItemRQ();
        finishFeatureRq.setEndTime(getTime());
        finishFeatureRq.setStatus(getFeatureStatus(featureResult));
        launch.get().finishTestItem(featureId, finishFeatureRq);
        //end of a feature file
    }

    synchronized private void setScenarioDetailsInReportPortal(ScenarioResult scenarioResult, FeatureResult featureResult, Maybe<String> featureId) {
       //sets scenario details in Report portal
        StartTestItemRQ startScenarioRq = new StartTestItemRQ();
        startScenarioRq.setDescription(scenarioResult.getScenario().getDescription());
        startScenarioRq.setName("Scenario: " + scenarioResult.getScenario().getName());
        startScenarioRq.setStartTime(new Date(scenarioResult.getStartTime()));
        startScenarioRq.setType(StatusEnum.STEP_TYPE);

        if (scenarioResult.getScenario().getTags() != null && !scenarioResult.getScenario().getTags().isEmpty()) {
            List<Tag> tags = featureResult.getFeature().getTags();
            Set<ItemAttributesRQ> attributes = extractAttributes(tags);
            startScenarioRq.setAttributes(attributes);
        }

        Maybe<String> scenarioId = launch.get().startTestItem(featureId, startScenarioRq);
        this.logStatus(getScenerioStatus(scenarioResult), scenarioResult, scenarioId);
        FinishTestItemRQ finishScenarioRq = buildStopScenerioRq(scenarioResult);
        finishScenarioRq.setEndTime(new Date(scenarioResult.getEndTime()));
        finishScenarioRq.setStatus(getScenerioStatus(scenarioResult));

        launch.get().finishTestItem(scenarioId, finishScenarioRq);
    }

    synchronized private StartTestItemRQ setFeatureDetailsInReportPortal(FeatureResult featureResult) {
        //sets feature name attributes and tags in report portal
        Feature feature = featureResult.getFeature();
        String featureUri = getUri(feature);

        StartTestItemRQ startFeatureRq = new StartTestItemRQ();
        startFeatureRq.setName(!Strings.isNullOrEmpty(feature.getName()) ? "Feature: " + feature.getName() : "Feature: " + featureUri);
        startFeatureRq.setType(StatusEnum.TEST_TYPE);
        startFeatureRq.setDescription(featureUri);

        if (featureStartDate.containsKey(featureUri)) {
            startFeatureRq.setStartTime(featureStartDate.get(featureUri));
        } else {
            startFeatureRq.setStartTime(getTime());
        }
        if (feature.getTags() != null && !feature.getTags().isEmpty()) {
            List<Tag> tags = feature.getTags();
            Set<ItemAttributesRQ> attributes = extractAttributes(tags);
            startFeatureRq.setAttributes(attributes);
        }
        return startFeatureRq;
    }

    private String getLaunchStatus(Suite suite) {
        String launchStatus = StatusEnum.SKIPPED;

        try {
            Stream<FeatureResult> featureResults = suite.getFeatureResults();

            if (featureResults.count() > 0) {
                Long failedCount = featureResults
                        .filter(s -> s.getScenarioCount() > 0)
                        .filter(s -> s.getFailedCount() > 0)
                        .collect(Collectors.counting());

                launchStatus = (failedCount > 0) ? StatusEnum.FAILED : StatusEnum.PASSED;
            }
        } catch (Exception e) {
            // do nothing
        }

        return launchStatus;
    }

    private Date getTime() {
        return Calendar.getInstance().getTime();
    }

    private String getUri(Feature feature) {
        return feature.getResource().getRelativePath();
    }

    private void sendLog(final String message, final String level, final String itemUuid) {
        ReportPortal.emitLog(itemId ->
        {
            SaveLogRQ saveLogRq = new SaveLogRQ();
            saveLogRq.setMessage(message);
            saveLogRq.setItemUuid(itemUuid);
            saveLogRq.setLevel(level);
            saveLogRq.setLogTime(getTime());

            return saveLogRq;
        });
    }

    static String getURI(Feature feature) {
        return feature.getResource().getPackageQualifiedName().toString();
    }

    private FinishTestItemRQ buildStopScenerioRq(ScenarioResult scenarioResult) {
        Date now = Calendar.getInstance().getTime();
        FinishTestItemRQ rq = new FinishTestItemRQ();
        if (scenarioResult != null && scenarioResult.getScenario() != null) {
            String featureUri = getURI(scenarioResult.getScenario().getFeature());
            if (featureStartDate.containsKey(featureUri)) {
                rq.setEndTime(new Date(scenarioResult.getEndTime() + featureStartDate.get(featureUri).getTime()));
            } else {
                rq.setEndTime(Calendar.getInstance().getTime());
            }
            rq.setStatus(this.getScenerioStatus(scenarioResult));
        }
        return rq;
    }

    private synchronized void logStatus(String status, ScenarioResult scenarioResult, Maybe<String> scenarioId) {
        List<Map<String, Map>> stepResultsToMap = (List<Map<String, Map>>) scenarioResult.toCucumberJson().get("steps");

        for (Map<String, Map> step : stepResultsToMap) {
            String logLevel = status.equals("PASSED") ? StatusEnum.INFO_LEVEL : StatusEnum.ERROR_LEVEL;
            if (step.get("doc_string") != null) {
                sendLog("STEP: " + step.get("name") +
                        "\n-----------------DOC_STRING-----------------\n" + step.get("doc_string"), logLevel, scenarioId.blockingGet());
            } else {
                sendLog("STEP: " + step.get("name"), logLevel, scenarioId.blockingGet());
            }
        }
    }

    private String getFeatureStatus(FeatureResult featureResult) {
        String status = StatusEnum.SKIPPED;
        if (featureResult.getScenarioCount() > 0) {
            if (featureResult.isFailed()) {
                status = StatusEnum.FAILED;
            } else {
                status = StatusEnum.PASSED;
            }
        }
        return status.toString();
    }

    private String getScenerioStatus(ScenarioResult scenarioResult) {
        String status = StatusEnum.SKIPPED;
        if (scenarioResult.getStepResults() != null && scenarioResult.getStepResults().size() > 0) {
            if (scenarioResult.getFailedStep() != null) {
                status = StatusEnum.FAILED;
            } else {
                status = StatusEnum.PASSED;
            }
        }
        return status.toString();
    }

    public static Set<ItemAttributesRQ> extractAttributes(List<Tag> tags) {
        Set<ItemAttributesRQ> attributes = new HashSet<ItemAttributesRQ>();
        tags.forEach((tag) -> {
            attributes.add(new ItemAttributesRQ(null, tag.getName()));
        });
        return attributes;
    }
}