package com.znsio;

import com.intuit.karate.Results;
import com.intuit.karate.junit5.Karate;
import com.jayway.jsonpath.JsonPath;
import org.joda.time.DateTime;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public class RunTest {
    private static final String workingDir = System.getProperty("user.dir");
    private final String reportsDirectory;
    private final String PROJECT_NAME = "com.com.znsio";
    private final String KARATE_REPORTS_DIR = "karate-reports";
    private final String CUCUMBER_REPORTS_DIR = "reports";
    private final String CUCUMBER_REPORTS_FILE_NAME = "/cucumber-html-reports/overview-features.html";
    private final String TEST_DATA_FILE_NAME = "src/test/java/test_data.json";
    private final String BASE_URL = "baseUrl";
    private final String ENVIRONMENT_KEY = "env";

    public RunTest() {
        reportsDirectory = getReportsDirectory();
    }

    @Test
    void runKarateTests() {
        Results results = Karate.run(getClasspath())
                .tags(getTags())
                .karateEnv(getKarateEnv())
                .reportDir(reportsDirectory + File.separator + KARATE_REPORTS_DIR)
                .outputCucumberJson(true)
                .outputJunitXml(true)
                .outputHtmlReport(true)
                .parallel(getParallelCount());
        generateReport(results.getReportDir());
    }

    private void generateReport(String karateOutputPath) {
        System.out.println("================================================================================================");
        System.out.println("===================================  Generating reports  =======================================");
        System.out.println("================================================================================================");
        java.util.Collection<java.io.File> jsonFiles = org.apache.commons.io.FileUtils
                .listFiles(new java.io.File(karateOutputPath), new String[]{"json"}, true);
        if(jsonFiles.size() == 0) {
            System.out.println("Reports NOT generated");
        } else {
            java.util.List<String> jsonPaths = new java.util.ArrayList<>(jsonFiles.size());
            jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
            net.masterthought.cucumber.Configuration config = new net.masterthought.cucumber.Configuration(
                    new java.io.File(getPath(reportsDirectory, CUCUMBER_REPORTS_DIR)), PROJECT_NAME);

//        config.setTagsToExcludeFromChart("@checkout", "@feature.*");
            addClassifications(config);

            net.masterthought.cucumber.ReportBuilder reportBuilder = new net.masterthought.cucumber.ReportBuilder(jsonPaths, config);
            reportBuilder.generateReports();
            System.out.println("Reports available here: \nfile://" + config.getReportDirectory().getAbsolutePath() + CUCUMBER_REPORTS_FILE_NAME);
        }
        System.out.println("================================================================================================");
    }

    private String getPath(String rootDirectory, String pathSuffix) {
        String[] testFilePaths = pathSuffix.split("/");
        for(int eachPath = 0; eachPath < testFilePaths.length; eachPath++) {
            rootDirectory += File.separator + testFilePaths[eachPath];
        }
        return rootDirectory;
    }

    private void addClassifications(net.masterthought.cucumber.Configuration config) {
        java.util.Map<String, Object> envConfig = null;
        String baseUrl = "";
        try {
            envConfig = JsonPath.parse(new File(getPath(workingDir, TEST_DATA_FILE_NAME))).read("$." + getKarateEnv(), Map.class);
            baseUrl = ((java.util.Map) envConfig.get(ENVIRONMENT_KEY)).get(BASE_URL).toString();
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
        return getPath(workingDir, "target/" + date + "/" + time);
    }

    private String getKarateEnv() {
        String karateEnv = System.getProperty("karate.env");
        if((null == karateEnv) || (karateEnv.isBlank())) {
            throw new RuntimeException("karate.env is not specified as a system property");
        }
        return karateEnv;
    }

    private List<String> getTags() {
        String customTagsToRun = System.getenv("tag");
        java.util.List<String> strings = new java.util.ArrayList<>();
        strings.add("~@ignore");
        strings.add("~@wip");
        strings.add("~@template");
        strings.add("~@data");
        if((null != customTagsToRun) && (!customTagsToRun.trim().isEmpty())) {
            strings.add(customTagsToRun);
        }
        strings.add(getEnvTag());
        System.out.println("Run tests with tags: " + strings);
        return strings;
    }

    private String getEnvTag() {
        String env = getKarateEnv();
        String envTag = ((null != env) && (!env.trim().isEmpty())) ? env.toLowerCase() : "@eat";
        if(!envTag.startsWith("@")) {
            envTag = "@" + envTag;
        }
        System.out.println("Run tests on environment: " + envTag);
        return envTag;
    }

    private String getClasspath() {
        String type = System.getenv("type");
        if(null == type) {
            throw new RuntimeException("type [api | workflow] is not provided");
        }
        String classPath = "classpath:com/znsio/" + type;
        System.out.printf("Running %s tests%n", classPath);
        return classPath;
    }

    private int getParallelCount() {
        String parallel = System.getProperty("parallel");
        int parallelCount = (null == parallel || parallel.isEmpty()) ? 5 : Integer.parseInt(parallel);
        System.out.printf("Parallel count: %d %n", parallelCount);
        return parallelCount;
    }
}
