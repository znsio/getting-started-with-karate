package com.znsio;

import com.epam.reportportal.karate.KarateReportPortalRunner;
import com.intuit.karate.Results;
import com.jayway.jsonpath.JsonPath;
import com.znsio.exceptions.TestExecutionException;
import org.joda.time.DateTime;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class RunTest {
    private static final String workingDir = System.getProperty("user.dir");
    private final String reportsDirectory;
    private final String PROJECT_NAME = "getting-started-with-karate";
    private final String KARATE_REPORTS_DIR = "karate-reports";
    private final String CUCUMBER_REPORTS_DIR = "reports";
    private final String CUCUMBER_REPORTS_FILE_NAME = "/cucumber-html-reports/overview-features.html";
    private final String TEST_DATA_FILE_NAME = "src/test/java/test_data.json";
    private final String BASE_URL = "baseUrl";
    private final String TARGET_ENVIRONMENT = "TARGET_ENVIRONMENT";

    public RunTest() {
        reportsDirectory = getReportsDirectory();
    }

    @Test
    void runKarateTests() {
        System.out.printf("Class: %s :: Test: runKarateTests%n", this.getClass().getSimpleName());
        List<String> tags = getTags();
        System.setProperty("rp.launch", PROJECT_NAME + " " + getTestType() + " tests");
        System.setProperty("rp.description", PROJECT_NAME + " " + getTestType() + " tests");
        System.setProperty("rp.launch.uuid.print", String.valueOf(Boolean.TRUE));
        System.setProperty("rp.client.join", String.valueOf(Boolean.FALSE));

        String rpAttributes = "";
        if (null != System.getenv("TAG")) {
            rpAttributes += "Tags:" + System.getenv("TAG");
        }
        rpAttributes += ";TargetEnvironment:" + getKarateEnv();
        rpAttributes += ";Type:" + getTestType();
        System.setProperty("rp.attributes", rpAttributes);
        Results results = KarateReportPortalRunner
                .path(getClasspath())
                .outputCucumberJson(true)
                .tags(tags)
                .karateEnv(getKarateEnv())
                .reportDir(reportsDirectory + File.separator + KARATE_REPORTS_DIR)
                .outputCucumberJson(true)
                .outputJunitXml(true)
                .outputHtmlReport(true)
                .parallel(getParallelCount());
        String reportFilePath = generateReport(results.getReportDir());
        String message = "\n\n" + "Test execution summary: ";
        message += "\n\t" + "Tags: " + tags;
        message += "\n\t" + "Environment: " + getKarateEnv();
        message += "\n\t" + "Parallel count: " + getParallelCount();
        message += "\n\t" + "Scenarios: Failed: " + results.getScenariosFailed() + ", Passed: " + results.getScenariosPassed() + ", Total: " + results.getScenariosTotal();
        message += "\n\t" + "Features : Failed: " + results.getFeaturesFailed() + ", Passed: " + results.getFeaturesPassed() + ", Total: " + results.getFeaturesTotal();
        message += "\n\t" + "Reports available here: file://" + reportFilePath;
        if (results.getScenariosFailed() > 0) {
            throw new TestExecutionException(message);
        } else {
            System.out.println(message);
        }
    }

    private String generateReport(String karateOutputPath) {
        System.out.println("================================================================================================");
        System.out.println("===================================  Generating reports  =======================================");
        System.out.println("================================================================================================");
        java.util.Collection<java.io.File> jsonFiles = org.apache.commons.io.FileUtils.listFiles(new java.io.File(karateOutputPath), new String[]{"json"}, true);
        String reportFilePath = null;
        if (jsonFiles.size() == 0) {
            System.out.println("Reports NOT generated");
        } else {
            java.util.List<String> jsonPaths = new java.util.ArrayList<>(jsonFiles.size());
            jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
            net.masterthought.cucumber.Configuration config = new net.masterthought.cucumber.Configuration(new File(getPath(reportsDirectory, CUCUMBER_REPORTS_DIR)), PROJECT_NAME);

            // config.setTagsToExcludeFromChart("@checkout", "@feature.*");
            addClassifications(config);

            net.masterthought.cucumber.ReportBuilder reportBuilder = new net.masterthought.cucumber.ReportBuilder(jsonPaths, config);
            reportBuilder.generateReports();
            reportFilePath = config.getReportDirectory().getAbsolutePath() + CUCUMBER_REPORTS_FILE_NAME;
        }
        System.out.println("================================================================================================");
        return reportFilePath;
    }

    private String getPath(String rootDirectory, String pathSuffix) {
        String[] testFilePaths = pathSuffix.split("/");
        for (int eachPath = 0; eachPath < testFilePaths.length; eachPath++) {
            rootDirectory += File.separator + testFilePaths[eachPath];
        }
        return rootDirectory;
    }

    private void addClassifications(net.masterthought.cucumber.Configuration config) {
        java.util.Map<String, Object> envConfig = null;
        String baseUrl = "";
        try {
            envConfig = JsonPath.parse(new File(getPath(workingDir, TEST_DATA_FILE_NAME))).read("$." + getKarateEnv() + ".env", Map.class);
            baseUrl = envConfig.get(BASE_URL).toString();
        } catch (IOException e) {
            System.out.println("Error in loading the test_data.json file");
        }

        config.addClassifications("Environment", getKarateEnv());
        config.addClassifications("Base url", baseUrl);
        config.addClassifications("Test Automation using", "Karate");
    }

    private String getReportsDirectory() {
        DateTime dateTime = DateTime.now();
        String date = dateTime.getDayOfMonth() + "-" + dateTime.getMonthOfYear() + "-" + dateTime.getYear();
        String time = dateTime.getHourOfDay() + "-" + dateTime.getMinuteOfHour() + "-" + dateTime.getSecondOfMinute();
        String reportsDirPath = getPath(workingDir, "target/" + date + "/" + time);
        System.out.println("Reports directory: " + reportsDirPath);
        return reportsDirPath;
    }

    private String getKarateEnv() {
        String karateEnv = System.getenv("TARGET_ENVIRONMENT");
        if ((null == karateEnv) || (karateEnv.isBlank())) {
            String message = "TARGET_ENVIRONMENT is not specified as an environment variable";
            System.out.println(message);
            throw new RuntimeException(message);
        }
        System.setProperty("karate.env", karateEnv);
        return karateEnv;
    }

    private List<String> getTags() {
        System.out.println("In " + this.getClass().getSimpleName() + " :: getTags");
        java.util.List<String> tagsToRun = new java.util.ArrayList<>();
        String customTagsToRun = System.getenv("TAG");
        if ((null != customTagsToRun) && (!customTagsToRun.trim().isEmpty())) {
            String[] customTags = customTagsToRun.trim().split(":");
            for (String customTag : customTags) {
                tagsToRun.addAll(List.of(customTag));
            }
        }
        tagsToRun.add(getEnvTag());
        tagsToRun.add("~@ignore");
        tagsToRun.add("~@wip");
        tagsToRun.add("~@template");
        tagsToRun.add("~@data");

        System.out.println("Run tests with tags: " + tagsToRun);
        return tagsToRun;
    }

    private String getEnvTag() {
        String env = getKarateEnv();
        String envTag = ((null != env) && (!env.trim().isEmpty())) ? env.toLowerCase() : "@prod";
        if (!envTag.startsWith("@")) {
            envTag = "@" + envTag;
        }
        System.out.println("Run tests on environment: " + envTag);
        return envTag;
    }

    private String getClasspath() {
        System.out.println("In " + this.getClass().getSimpleName() + " :: getClassPath");
        String type = getTestType();
        String classPath = "classpath:com/znsio/" + type;
        System.out.printf("Running %s tests%n", classPath);
        return classPath;
    }

    private static String getTestType() {
        String type = System.getenv("TYPE");
        if (null == type) {
            System.out.println("TYPE [api | workflow] is not provided");
            throw new RuntimeException("TYPE [api | workflow] is not provided");
        }
        return type.toLowerCase(Locale.ROOT);
    }

    private int getParallelCount() {
        String parallel = System.getenv("PARALLEL");
        int parallelCount = (null == parallel || parallel.isEmpty()) ? 5 : Integer.parseInt(parallel);
        System.out.printf("Parallel count: %d %n", parallelCount);
        return parallelCount;
    }
}
