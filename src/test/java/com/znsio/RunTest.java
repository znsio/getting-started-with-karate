package com.znsio;

import com.epam.reportportal.karate.KarateReportPortalRunner;
import com.intuit.karate.Results;
import com.jayway.jsonpath.JsonPath;
import com.znsio.exceptions.TestDataException;
import com.znsio.exceptions.TestExecutionException;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import static com.znsio.OverriddenVariable.getOverriddenStringValue;

public class RunTest {
    private static final String WORKING_DIR = System.getProperty("user.dir");
    private static final String NOT_SET = "NOT_SET";
    private static final String LOCAL_RUN = "LOCAL_RUN";
    private static final String NA = "N/A";
    private final String reportsDirectory;
    private static final String KARATE_REPORTS_DIR = "karate-reports";
    private static final String CUCUMBER_REPORTS_DIR = "reports";
    private static final String CUCUMBER_REPORTS_FILE_NAME = "/cucumber-html-reports/overview-features.html";
    private static final String TEST_DATA_FILE_NAME_LOCAL = "src/test/java/test_data.json";
    private final String TEST_DATA_FILE_NAME;
    private static final String TEST_DATA_FILE_NAME_FAT_JAR = "test_data.json";
    private static final String BASE_URL = "baseUrl";
    private static final String TARGET_ENVIRONMENT = "TARGET_ENVIRONMENT";

    private static final HashMap testMetadata = new HashMap<>();
    private static List<Map.Entry<String, Integer>> sortedTestMetaDataKeys;
    private static Map<String, Object> envConfig;
    private static Map<String, Object> testDataConfig;

    /* Begin: Custom properties section */
    /* Update these values as appropriate to your framework */

    // environment variable that indicates if build was manually triggrerd, or auto-triggered
    private static final String BUILD_INITIATION_REASON = "BUILD_INITIATION_REASON";

    // environment variable that has the id for the build
    private static final String BUILD_ID = "BUILD_ID";

    // name of your project/team/repo
    private final String PROJECT_NAME = "getting-started-with-karate";

    /* End: Custom properties section */

    public RunTest() {
        if (null != System.getProperty("IS_FATJAR_RUNNER")) {
            TEST_DATA_FILE_NAME = TEST_DATA_FILE_NAME_FAT_JAR;
        } else {
            TEST_DATA_FILE_NAME = TEST_DATA_FILE_NAME_LOCAL;
        }
        System.out.printf("TEST_DATA_FILE_NAME: %s%n", TEST_DATA_FILE_NAME);
        reportsDirectory = getReportsDirectory();
        getEnvConfig();
        captureTestExecutionMetadata();
    }

    private static String getBuildInitiationReason() {
        return getOverriddenStringValue(BUILD_INITIATION_REASON, LOCAL_RUN);
    }

    private static String getHostMachineName() {
        try {
            return InetAddress.getLocalHost().getHostName();
        } catch (UnknownHostException e) {
            System.out.println("Error fetching machine name: " + e.getMessage());
            return NOT_SET;
        }
    }

    private static String getTestType() {
        String type = System.getenv("TYPE");
        if (null == type) {
            System.out.println("TYPE [api | workflow] is not provided");
            throw new TestDataException("TYPE [api | workflow] is not provided");
        }
        return type.toLowerCase(Locale.ROOT);
    }

    @Test
    void runKarateTests() {
        System.out.printf("Class: %s :: Test: runKarateTests%n", this.getClass().getSimpleName());
        List<String> tags = getTags();
        System.setProperty("rp.launch", PROJECT_NAME + " " + getTestType() + " tests");
        System.setProperty("rp.description", PROJECT_NAME + " " + getTestType() + " tests");
        System.setProperty("rp.launch.uuid.print", String.valueOf(Boolean.TRUE));
        System.setProperty("rp.client.join", String.valueOf(Boolean.FALSE));
        System.setProperty("rp.attributes", getRpAttributes());
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

    private String getRpAttributes() {
        StringBuilder rpAttributes = new StringBuilder();
        for (Map.Entry<String, Integer> entry : sortedTestMetaDataKeys) {
            System.out.println(entry.getKey() + " : " + entry.getValue());
            rpAttributes.append(entry.getKey()).append(":").append(entry.getValue()).append(";");
        }

        System.out.println("rpAttributes: " + rpAttributes);
        return rpAttributes.toString();
    }

    private void captureTestExecutionMetadata() {
        testMetadata.put("RunByFatJarRunner", System.getProperty("IS_FATJAR_RUNNER", Boolean.FALSE.toString()));
        testMetadata.put("TargetEnvironment", getKarateEnv());
        testMetadata.put("Type", getTestType());
        testMetadata.put("ParallelCount", getParallelCount());
        testMetadata.put("LoggedInUser", System.getProperty("user.name"));
        testMetadata.put("JavaVersion", System.getProperty("java.specification.version"));
        testMetadata.put("OS", System.getProperty("os.name"));
        testMetadata.put("HostName", getHostMachineName());
        testMetadata.put("BuildInitiationReason", getBuildInitiationReason());
        testMetadata.put("BuildId", getBuildId());
        testMetadata.put("BaseUrl", getBaseUrl());
        testMetadata.put("RunInCI", getIsRunInCI());
        if (null != System.getenv("TAG")) {
            testMetadata.put("Tags", System.getenv("TAG"));
        }

        // Convert hashmap entries to a list
        sortedTestMetaDataKeys = new ArrayList<>(testMetadata.entrySet());

        // Sort the list by keys
        Collections.sort(sortedTestMetaDataKeys, new Comparator<Map.Entry<String, Integer>>() {
            public int compare(Map.Entry<String, Integer> o1, Map.Entry<String, Integer> o2) {
                return o1.getKey().compareTo(o2.getKey());
            }
        });
    }

    private String getBuildId() {
        return getOverriddenStringValue(BUILD_ID, NA);
    }

    private boolean getIsRunInCI() {
        return (!getBuildInitiationReason().equals(LOCAL_RUN));
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

            int count = 0;
            String[] envList = new String[testDataConfig.keySet().size()];
            for (Map.Entry<String, Object> stringObjectEntry : testDataConfig.entrySet()) {
                envList[count] = "@" + stringObjectEntry.getKey();
                count++;
            }

            config.setTagsToExcludeFromChart(envList);
            addClassifications(config);
            System.out.println("Excluded tags from Cucumber-html tag report: " + config.getTagsToExcludeFromChart());

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
        System.out.printf("Path for: '%s' is: '%s'%n", pathSuffix, rootDirectory);
        return rootDirectory;
    }

    private void addClassifications(net.masterthought.cucumber.Configuration config) {
        for (Map.Entry<String, Integer> entry : sortedTestMetaDataKeys) {
            System.out.println(entry.getKey() + " : " + entry.getValue());
            config.addClassifications(entry.getKey(), String.valueOf(entry.getValue()));
        }
    }

    private String getBaseUrl() {
        return envConfig.get(BASE_URL).toString();
    }

    private void getEnvConfig() {
        String testDataFilePath = getPath(WORKING_DIR, TEST_DATA_FILE_NAME);
        System.out.println("Test Data file path: " + testDataFilePath);
        try {
            testDataConfig = JsonPath.parse(new File(testDataFilePath)).read("$", Map.class);
            envConfig = JsonPath.parse(testDataConfig).read("$." + getKarateEnv() + ".env", Map.class);
        } catch (IOException e) {
            throw new TestDataException(String.format("Unable to load test data file: '%s'", TEST_DATA_FILE_NAME), e);
        }
    }

    private static String getCurrentDatestamp(Date today) {
        SimpleDateFormat df = new SimpleDateFormat("MM-dd-yyyy");
        return df.format(today);
    }

    private static String getMonth(Date today) {
        SimpleDateFormat df = new SimpleDateFormat("MMM-yyyy");
        return df.format(today);
    }

    private static String getCurrentTimestamp(Date today) {
        SimpleDateFormat df = new SimpleDateFormat("HH-mm-ss");
        return df.format(today);
    }

    private String getReportsDirectory() {
        Date today = new Date();
        String reportsDirPath = getPath(WORKING_DIR,
                                    "target" + File.separator
                                            + getMonth(today) + File.separator
                                            + getCurrentDatestamp(today) + File.separator
                                            + getCurrentTimestamp(today));
        System.out.println("Reports directory: " + reportsDirPath);
        return reportsDirPath;
    }

    private String getKarateEnv() {
        String karateEnv = System.getenv(TARGET_ENVIRONMENT);
        if ((null == karateEnv) || (karateEnv.isBlank())) {
            String message = "TARGET_ENVIRONMENT is not specified as an environment variable";
            System.out.println(message);
            throw new TestDataException(message);
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

    private int getParallelCount() {
        String parallel = System.getenv("PARALLEL");
        int parallelCount = (null == parallel || parallel.isEmpty()) ? 5 : Integer.parseInt(parallel);
        System.out.printf("Parallel count: %d %n", parallelCount);
        return parallelCount;
    }
}
