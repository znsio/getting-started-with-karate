package com.znsio.reportPortal;

import com.intuit.karate.RuntimeHook;
import com.intuit.karate.Suite;
import com.intuit.karate.core.FeatureRuntime;
import com.intuit.karate.core.ScenarioRuntime;
import com.intuit.karate.core.Step;
import com.intuit.karate.core.StepResult;
import com.intuit.karate.Runner;
import com.intuit.karate.Results;
import io.reactivex.Maybe;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;

public class KarateReportPortalHook implements RuntimeHook {
    // Overrides karate before/after methods to send results on report portal
    private RPReporter rpReporter;
    private static final Logger logger = LoggerFactory.getLogger(KarateReportPortalHook.class);
    HashMap <String,Maybe<String>> featureIdentifier=new HashMap<>();
    HashMap <String,Maybe<String>> scenarioIdentifier=new HashMap<>();

    public KarateReportPortalHook() {
        this.rpReporter = new RPReporter();
    }

    @Override
    public boolean beforeScenario(ScenarioRuntime sr) {
        if(this.rpReporter.isTemplate(sr.scenario))
            return false;
        if(featureIdentifier.containsKey(sr.scenario.getFeature().getName())) {
            Maybe<String> scenarioId=this.rpReporter.launchScenarioToReportPortal(sr.result, featureIdentifier.get(sr.scenario.getFeature().getName()));;
            scenarioIdentifier.put(sr.scenario.getUniqueId(),scenarioId);
        }
        return true;
    }

    @Override
    public void afterScenario(ScenarioRuntime sr) {
        if(!this.rpReporter.isTemplate(sr.scenario))
            if(scenarioIdentifier.containsKey(sr.scenario.getUniqueId()))
                this.rpReporter.finishScenarioInReportPortal(sr.result,scenarioIdentifier.get(sr.scenario.getUniqueId()));
    }

    @Override
    public boolean beforeFeature(FeatureRuntime fr) {
        try {
            this.rpReporter.startFeature(fr.feature);
            if (!this.rpReporter.isTemplate(fr.feature)) {
                Maybe<String> featureId = this.rpReporter.launchFeatureToReportPortal(fr.result);
                featureIdentifier.put(fr.feature.getName(),featureId);
            }

        } catch (Exception e) {
            logger.error("beforeFeature exception: {}", e.getMessage(), e);
        }

        return true;
    }

    @Override
    public void afterFeature(FeatureRuntime fr) {
        try {
            if (!this.rpReporter.isTemplate(fr.feature)) {
                this.rpReporter.finishFeature(fr.result,featureIdentifier.get(fr.feature.getName()));
            }
        } catch (Exception e) {
            logger.error("afterFeature exception: {}", e.getMessage(), e);
        }
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
    public void afterSuite(Suite suite) {
        try {
            this.rpReporter.finishLaunch(suite);
            System.out.println("After suite result "+featureIdentifier);
        } catch (Exception e) {
            logger.error("afterSuite exception: {}", e.getMessage(), e);
        }
    }

    @Override
    public boolean beforeStep(Step step, ScenarioRuntime sr) {
        return true;
    }

    @Override
    public void afterStep(StepResult result, ScenarioRuntime sr) {
        this.rpReporter.writeStepToReportPortal(result,sr.result,scenarioIdentifier.get(sr.scenario.getUniqueId()));
    }
}