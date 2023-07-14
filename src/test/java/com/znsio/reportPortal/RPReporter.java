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
import org.junit.jupiter.api.Assertions;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.google.common.base.Strings.isNullOrEmpty;

class RPReporter {
    private final Map<String, Date> featureStartDate = Collections.synchronizedMap(new HashMap<String, Date>());
    private static final Logger LOGGER = Logger.getLogger(RPReporter.class.getName());
    private Supplier<Launch> launch;
    int step;
    HashMap <Maybe<String>,String> templateSteps=new HashMap<>();
    Map<Long,List<Step>> templateStep = new HashMap<>();
    Map<Long,List<String>> templateStepLog= new HashMap<>();
    Map<Long,List<Boolean>> templateStepResult= new HashMap<>();

    RPReporter() {
    }

    void startLaunch() {
        // Launch report portal and set different attributes
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
        // Finishes launch in ReportPortal. Blocks until all items are reported correctly
        FinishExecutionRQ finishLaunchRq = new FinishExecutionRQ();
        finishLaunchRq.setEndTime(getTime());
        finishLaunchRq.setStatus(getLaunchStatus(suite));
        System.out.println("total step calls "+step);
        launch.get().finish(finishLaunchRq);
    }

    synchronized boolean isTemplate(Feature feature) {
        // return boolean based on if the feature has tag "@template". If true, then the feature won't get displayed on reportPortal.
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
        // return boolean based on if the scenario has tag "@template". If true, then the scenario won't get displayed on reportPortal.
        if (scenario != null) {
            List<Tag> scenarioTags = scenario.getTags();
            if (scenarioTags != null && !scenarioTags.isEmpty()) {
                for (Tag tag : scenarioTags) {
                    if (tag.getName().equalsIgnoreCase("template")) return true;
                }
            }
        }
        return false;
    }

    synchronized void startFeature(Feature feature) {
        featureStartDate.put(getUri(feature), getTime());
        // set the feature start date and time
    }

    synchronized void finishFeature(FeatureResult featureResult,Maybe<String> featureId) {

//        StartTestItemRQ startFeatureRq = this.setFeatureDetailsInReportPortal(featureResult);
//        Maybe<String> featureId = launch.get().startTestItem(null, startFeatureRq);
        //launches feature to report portal and logs it

//        for (ScenarioResult scenarioResult : featureResult.getScenarioResults()) {
//            //for multiple scenarios inside a features it will log each scenario inside the feature
//            this.setScenarioDetailsInReportPortal(scenarioResult, featureResult, featureId);
//        }

        FinishTestItemRQ finishFeatureRq = new FinishTestItemRQ();
        finishFeatureRq.setEndTime(getTime());
        finishFeatureRq.setStatus(getFeatureStatus(featureResult));
        launch.get().finishTestItem(featureId, finishFeatureRq);
        //end of a feature file
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
        // return report portal launch status
        String launchStatus = StatusEnum.SKIPPED;

        try {
            Stream<FeatureResult> featureResults = suite.getFeatureResults();

            if (featureResults.count() > 0) {
                Long failedCount = featureResults.filter(s -> s.getScenarioCount() > 0).filter(s -> s.getFailedCount() > 0).collect(Collectors.counting());

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
        ReportPortal.emitLog(itemId -> {
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
        // After completion of each scenario returns the results
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

    private String getFeatureStatus(FeatureResult featureResult) {
        // return feature status
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
        // return scenario status
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
        // returns tags used at feature/scenario level
        Set<ItemAttributesRQ> attributes = new HashSet<ItemAttributesRQ>();
        tags.forEach((tag) -> {
            attributes.add(new ItemAttributesRQ(null, tag.getName()));
        });
        return attributes;
    }

    synchronized public Maybe<String> launchFeatureToReportPortal(FeatureResult featureResult) {
        StartTestItemRQ startFeatureRq = this.setFeatureDetailsInReportPortal(featureResult);
        return launch.get().startTestItem(null, startFeatureRq);
    }

    synchronized public Maybe<String> launchScenarioToReportPortal(ScenarioResult scenarioResult, Maybe<String> featureId) {
        String scenario="Scenario : ";
        StartTestItemRQ startScenarioRq = new StartTestItemRQ();
        startScenarioRq.setDescription(scenarioResult.getScenario().getDescription());
        if(scenarioResult.getScenario().isOutlineExample())
            scenario="Scenario Outline : ";
        startScenarioRq.setName(scenario + scenarioResult.getScenario().getName());
        startScenarioRq.setStartTime(new Date(scenarioResult.getStartTime()));
        startScenarioRq.setType(StatusEnum.STEP_TYPE);


        if (scenarioResult.getScenario().getTags() != null && !scenarioResult.getScenario().getTags().isEmpty()) {
            List<Tag> tags = scenarioResult.getScenario().getTags();
            Set<ItemAttributesRQ> attributes = extractAttributes(tags);
            startScenarioRq.setAttributes(attributes);
        }
        return launch.get().startTestItem(featureId, startScenarioRq);
    }

    synchronized public void finishScenarioInReportPortal(ScenarioResult scenarioResult, Maybe<String> scenarioId) {
//        this.logStatus(getScenerioStatus(scenarioResult), scenarioResult, scenarioId);
        FinishTestItemRQ finishScenarioRq = buildStopScenerioRq(scenarioResult);
        finishScenarioRq.setEndTime(new Date(scenarioResult.getEndTime()));
        finishScenarioRq.setStatus(getScenerioStatus(scenarioResult));

        launch.get().finishTestItem(scenarioId, finishScenarioRq);
    }


//    @com.epam.reportportal.annotations.Step("{stepResult}")
    synchronized protected void writeStepToReportPortal(StepResult stepResult, ScenarioResult scenarioResult, Maybe<String> scenarioId) {
        step++;
        if(scenarioId==null) {
            this.logTemplateSteps(stepResult,!stepResult.isFailed());
            return;
        }
        System.out.println("Current active thread scenario name  "+scenarioResult.getScenario().getName()+" "+ Thread.currentThread().getId());
        boolean stepFailed = stepResult.isFailed();
        String logLevel = stepFailed ? StatusEnum.ERROR_LEVEL : StatusEnum.INFO_LEVEL;
        String background=stepResult.getStep().isBackground() ? "Background : ":"";
        if(stepFailed){

            this.putStepInScenario(background+stepResult.getStep().toString(),stepResult.getStepLog(),logLevel,scenarioId.blockingGet());
//            this.putStepInScenario(stepResult,logLevel,scenarioId.blockingGet());

//            sendLog(stepResult.getStep().toString() + "\n-----------------DOC_STRING-----------------\n"+stepResult.getErrorMessage(), logLevel,scenarioId.blockingGet());
//            sendLog(stepResult.getStep().toString() +"\n "+templateSteps.get(null)+ "\n-----------------DOC_STRING-----------------\n"+stepResult.getErrorMessage(), logLevel,scenarioId.blockingGet());
        }
        else {
            this.putStepInScenario(background+stepResult.getStep().toString(), stepResult.getStepLog(), logLevel, scenarioId.blockingGet());
//            this.putStepInScenario(background+stepResult.getStep().toString(), stepResult.getStepLog(), logLevel, scenarioId.blockingGet());

        }
        templateStep.remove(Thread.currentThread().getId());
        templateStepLog.remove(Thread.currentThread().getId());
        templateStepResult.remove(Thread.currentThread().getId());

    }

//    @com.epam.reportportal.annotations.Step("{stepResult} ")
    synchronized void putStepInScenario(String stepResult, String stepLog, String logLevel, String sId) {

        this.sendLog(stepResult+"\n"+stepLog,logLevel,sId);
        if(templateStep.get(Thread.currentThread().getId())!=null && templateStepLog.get(Thread.currentThread().getId())!=null)
            this.logSteps(" Calls Made for above STEP :");

//        if(templateStep.get(Thread.currentThread().getId())!=null && templateStepLog.get(Thread.currentThread().getId())!=null) {
//            List<Step> templateStepsList=templateStep.get(Thread.currentThread().getId());
//            List<String> templateStepsLogList=templateStepLog.get(Thread.currentThread().getId());
//            int max= Math.max(templateStepsList.size(), templateStepsLogList.size());
//            System.out.println("lenght templateStep "+templateStepsList.size()+" lenght templateStepLog "+templateStepsLogList.size());
//            for(int index=0;index<max;index++)
//            {
////                this.putTemplateLogsInStep(templateStepsList.get(index),templateStepsLogList.get(index),index);
////                this.putTemplateStepsLogsInTemplateLogs(templateStepsLogList.get(i));
//                ReportPortal.emitLog(String.valueOf(templateStepsList.get(index)),logLevel,new Date());
//            }
//        }
    }

    @com.epam.reportportal.annotations.Step("{stepCalls}")
    private void logSteps(String stepCalls) {
            List<Step> templateStepsList=templateStep.get(Thread.currentThread().getId());
            List<String> templateStepsLogList=templateStepLog.get(Thread.currentThread().getId());
            List<Boolean> templateStepResultList=templateStepResult.get(Thread.currentThread().getId());
            int max= Math.max(templateStepsList.size(), templateStepsLogList.size());
            System.out.println("lenght templateStep "+templateStepsList.size()+" lenght templateStepLog "+templateStepsLogList.size());
            for(int index=0;index<max;index++)
            {
                ReportPortal.emitLog(String.valueOf(templateStepsList.get(index)),templateStepResultList.get(index) ? StatusEnum.INFO_LEVEL : StatusEnum.ERROR_LEVEL,new Date());
                if(!String.valueOf(templateStepsLogList.get(index)).isEmpty())
                    ReportPortal.emitLog(String.valueOf(templateStepsLogList.get(index)),templateStepResultList.get(index) ? StatusEnum.STEP_TYPE : StatusEnum.ERROR_LEVEL,new Date());

            }

    }

    @com.epam.reportportal.annotations.Step("{step}")
    private void putTemplateLogsInStep(Step step,String stepLogs,int index) {
//        LOGGER.info("info "+step.toString());
        putTemplateStepsLogsInTemplateLogs(stepLogs);

//        return templateStepResult.get(index);


    }
    @com.epam.reportportal.annotations.Step("{stepLogs}")
    private void putTemplateStepsLogsInTemplateLogs(String stepLogs) {
//        LOGGER.info("info "+step.toString());

    }

    synchronized void logTemplateSteps(StepResult stepResult, boolean hasStepPassed) {

        long currentThread=Thread.currentThread().getId();
        if(!templateStep.containsKey(currentThread)){
            templateStep.put(currentThread,new ArrayList<Step>());
        }
        templateStep.get(currentThread).add(stepResult.getStep());

        if(!templateStepLog.containsKey(currentThread)){
            templateStepLog.put(currentThread,new ArrayList<String>());
        }
        templateStepLog.get(currentThread).add(stepResult.getStepLog());

        if(!templateStepResult.containsKey(currentThread)){
            templateStepResult.put(currentThread,new ArrayList<Boolean>());
        }
        templateStepResult.get(currentThread).add(hasStepPassed);

//        templateStepResult.add(hasStepPassed);


    }

     synchronized boolean isScenarioTemplate(ScenarioResult scenarioResult) {
        // return boolean based on if the Scenario has a tag starting with @t_  . If true, then the feature won't get displayed on reportPortal.
         if (scenarioResult.getScenario().getTags() != null && !scenarioResult.getScenario().getTags().isEmpty()) {
             List<Tag> tags = scenarioResult.getScenario().getTags();
             return (tags.toString().startsWith("[@t_"));
         }
         return false;

    }

    synchronized boolean isRandomizer(Feature feature) {
        return feature.getName().equalsIgnoreCase("Randomizer Utilities");
    }

}