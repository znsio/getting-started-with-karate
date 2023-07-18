package com.znsio.reportPortal;

import com.intuit.karate.RuntimeHook;
import com.intuit.karate.Suite;
import com.intuit.karate.core.FeatureRuntime;
import com.intuit.karate.core.ScenarioRuntime;
import com.intuit.karate.core.Step;
import com.intuit.karate.core.StepResult;
import io.reactivex.Maybe;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class KarateReportPortalHook implements RuntimeHook {
    // Overrides karate before/after methods to send results on report portal
    private RPReporter rpReporter;
    private static final Logger logger = LoggerFactory.getLogger(KarateReportPortalHook.class);
    HashMap<String, Maybe<String>> featureIdentifier = new HashMap<>();
    HashMap<String, Maybe<String>> scenarioIdentifier = new HashMap<>();

    public KarateReportPortalHook() {
        this.rpReporter = new RPReporter();
    }

    @Override
    public void beforeSuite(Suite suite) {
        try {
            this.rpReporter.startLaunch();
        } catch (Exception e) {
            logger.error("beforeSuite exception: {}", e.getMessage(), e);
        }
    }

    @Override
    public boolean beforeFeature(FeatureRuntime fr) {
        //ignoring randomizer feauter which is being called in karate-config.js
        //starting feature in RP
        try {
            this.rpReporter.startFeature(fr.feature);
            if (!this.rpReporter.isTemplate(fr.feature) && !this.rpReporter.isRandomizer(fr.feature)) {
                Maybe<String> featureId = this.rpReporter.launchFeatureToReportPortal(fr.result);
                if (featureId != null) featureIdentifier.put(fr.feature.getName(), featureId);
            }
        } catch (Exception e) {
            logger.error("beforeFeature exception: {}", e.getMessage(), e);
        }

        return true;
    }

    @Override
    public boolean beforeScenario(ScenarioRuntime sr) {
        //starting scenario inside a feature using its feature id
        //ignoring template to be logged as sceanrio inside a feature
        if (featureIdentifier.get(sr.scenario.getFeature().getName()) != null && !this.rpReporter.isScenarioTemplate(sr.result)) {
            Maybe<String> scenarioId = this.rpReporter.launchScenarioToReportPortal(sr.result, featureIdentifier.get(sr.scenario.getFeature().getName()));
            if (scenarioId != null) scenarioIdentifier.put(sr.scenario.getUniqueId(), scenarioId);
        }
        return true;
    }

    @Override
    public boolean beforeStep(Step step, ScenarioRuntime sr) {
        return true;
    }

    @Override
    public void afterStep(StepResult result, ScenarioRuntime sr) {
        //loggin steps to RP
        //storing and loggin template calls made by a step in RP
        if (scenarioIdentifier.containsKey(sr.scenario.getUniqueId()) || this.rpReporter.isScenarioTemplate(sr.result))
            this.rpReporter.writeStepToReportPortal(result, sr.result, scenarioIdentifier.get(sr.scenario.getUniqueId()));
    }

    @Override
    public void afterScenario(ScenarioRuntime sr) {
        //finishing a Scenario in RP
        //removing the sceanrio id from scenarioIdentifier map
        if (scenarioIdentifier.containsKey(sr.scenario.getUniqueId())) {
            this.rpReporter.finishScenarioInReportPortal(sr.result, scenarioIdentifier.get(sr.scenario.getUniqueId()));
            scenarioIdentifier.remove(sr.scenario.getUniqueId());
        }
    }

    @Override
    public void afterFeature(FeatureRuntime fr) {
        //finishing a Feature in RP
        //removing the featureIdentifier id from featureIdentifier map
        try {
            if (!this.rpReporter.isTemplate(fr.feature) && featureIdentifier.get(fr.feature.getName()) != null) {
                this.rpReporter.finishFeature(fr.result, featureIdentifier.get(fr.feature.getName()));
                featureIdentifier.remove(fr.feature.getName());
            }
        } catch (Exception e) {
            logger.error("afterFeature exception: {}", e.getMessage(), e);
        }
    }


    @Override
    public void afterSuite(Suite suite) {
        try {
            this.rpReporter.finishLaunch(suite);
        } catch (Exception e) {
            logger.error("afterSuite exception: {}", e.getMessage(), e);
        }
    }

}