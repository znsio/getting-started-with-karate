package com.znsio;

import org.junit.platform.launcher.Launcher;
import org.junit.platform.launcher.LauncherDiscoveryRequest;
import org.junit.platform.launcher.TestPlan;
import org.junit.platform.launcher.core.LauncherDiscoveryRequestBuilder;
import org.junit.platform.launcher.core.LauncherFactory;
import org.junit.platform.launcher.listeners.SummaryGeneratingListener;
import org.junit.platform.launcher.listeners.TestExecutionSummary;
import org.junit.platform.launcher.listeners.TestExecutionSummary.Failure;

import java.io.PrintWriter;

import static org.junit.platform.engine.discovery.DiscoverySelectors.selectClass;

public class FatJarRunner {

    SummaryGeneratingListener listener = new SummaryGeneratingListener();

    public void runAll() {
        System.out.println("In " + FatJarRunner.class.getSimpleName() + " :: runAll");
        LauncherDiscoveryRequest request = LauncherDiscoveryRequestBuilder.request()
                                                                          .selectors(selectClass(RunTest.class))
                                                                          .build();
        Launcher launcher = LauncherFactory.create();
        TestPlan testPlan = launcher.discover(request);
        launcher.registerTestExecutionListeners(listener);
        launcher.execute(request);
    }

    public static void main(String[] args) {
        System.out.println("Started " + FatJarRunner.class.getSimpleName());
        FatJarRunner runner = new FatJarRunner();
        runner.runAll();

        TestExecutionSummary summary = runner.listener.getSummary();
        summary.printTo(new PrintWriter(System.out));
        if(summary.getTestsAbortedCount() > 0 || summary.getTestsFailedCount() > 0) {
            String testFailureSummary = "";
            for(Failure failure : summary.getFailures()) {
                testFailureSummary += failure.getTestIdentifier()
                                             .getDisplayName() + "->\n" + failure.getException()
                                                                                 .toString() + "\n";
            }

            throw new RuntimeException("Tests failed" + testFailureSummary);
        }
    }
}
