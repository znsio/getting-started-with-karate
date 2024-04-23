package com.znsio.apiteswiz;

import com.epam.reportportal.karate.KarateReportPortalRunner;
import com.intuit.karate.Results;
import com.jayway.jsonpath.JsonPath;
import com.znsio.apiteswiz.exceptions.InvalidTestDataException;
import com.znsio.apiteswiz.exceptions.TestExecutionException;
import org.junit.jupiter.api.Test;

import javax.validation.constraints.NotNull;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import static com.znsio.apiteswiz.OverriddenVariable.getOverriddenStringValue;

public class RunTest {

    private final int parallelCount;
    private final String buildId;
    private final String buildInitiationReason;
    private final String cucumberReportsDirName;
    private final String cucumberReportsFileName;
    private final String karateReportsDirName;
    private final String projectName;
    private final String osName = System.getProperty("os.name");
    private final String javaVersion = System.getProperty("java.specification.version");
    private final String userName = System.getProperty("user.name");
    private final String testType;
    private final String DEFAULT_CUCUMBER_REPORTS_FILE_NAME = "cucumber-html-reports";
    private final String DEFAULT_CUCUMBER_REPORTS_DIR_NAME = "cucumber-reports";
    private final String DEFAULT_KARATE_REPORTS_DIR_NAME = "karate-reports";
    private final String DEFAULT_PARALLEL_COUNT = "5";
    private final String DEFAULT_TEST_DATA_FILENAME = "./src/test/java/test_data.json";

    private static final String WORKING_DIR = System.getProperty("user.dir");
    private static final String NOT_SET = "NOT_SET";
    private static final String LOCAL_RUN = "LOCAL_RUN";
    private static final String NA = "N/A";
    private final String reportsDirectory;
    private static final String BASE_URL = "baseUrl";
    private final String LOG_DIR = "LOG_DIR";

    private static final HashMap testMetadata = new HashMap<>();
    private static List<Map.Entry<String, Integer>> sortedTestMetaDataKeys;
    private static Map<String, Object> envConfig;
    private static Map<String, Object> testDataConfig;
    private static Properties properties;
    private final String karateEnv;
    private final String testDataFile;
    private final String rpEnable;
    private final String DEFAULT_CONFIG_FILE_NAME = "./src/test/java/config.properties";

    private enum Metadata {
        BUILD_ID_ENV_VAR,
        BUILD_INITIATION_REASON_ENV_VAR,
        CUCUMBER_REPORTS_DIR_NAME,
        CUCUMBER_REPORTS_FILE_NAME,
        KARATE_REPORTS_DIR_NAME,
        PARALLEL_COUNT,
        PROJECT_NAME,
        RP_ENABLE,
        TEST_DATA_FILE_NAME,
        TEST_TYPE,
        TARGET_ENVIRONMENT,
        CONFIG_FILE
    }

    public RunTest() {
        System.out.println("config file name: " + getConfigFileName());
        properties = loadProperties(getConfigFileName());
        reportsDirectory = getReportsDirectory();
        buildId = getOverloadedValueFor(Metadata.BUILD_ID_ENV_VAR, NOT_SET);
        buildInitiationReason = getOverloadedValueFor(Metadata.BUILD_INITIATION_REASON_ENV_VAR, NOT_SET);
        cucumberReportsDirName = getOverloadedValueFromPropertiesFor(Metadata.CUCUMBER_REPORTS_DIR_NAME, DEFAULT_CUCUMBER_REPORTS_DIR_NAME);
        cucumberReportsFileName = getOverloadedValueFromPropertiesFor(Metadata.CUCUMBER_REPORTS_FILE_NAME, DEFAULT_CUCUMBER_REPORTS_FILE_NAME);
        karateReportsDirName = getOverloadedValueFromPropertiesFor(Metadata.KARATE_REPORTS_DIR_NAME, DEFAULT_KARATE_REPORTS_DIR_NAME);
        parallelCount = Integer.parseInt(getOverloadedValueFromPropertiesFor(Metadata.PARALLEL_COUNT, DEFAULT_PARALLEL_COUNT));
        projectName = getOverloadedValueFromPropertiesFor(Metadata.PROJECT_NAME, WORKING_DIR);
        rpEnable = getOverloadedValueFromPropertiesFor(Metadata.RP_ENABLE, String.valueOf(false));
        testDataFile = getTestDataFileName();
        testType = getOverloadedValueFromPropertiesFor(Metadata.TEST_TYPE, NOT_SET);
        karateEnv = getOverloadedValueFromPropertiesFor(Metadata.TARGET_ENVIRONMENT, NOT_SET);

        loadEnvConfig();
        captureTestExecutionMetadata();
    }

    public String getConfigFileName() {
        String configFileToUse = NOT_SET;
        String providedConfigFileName = System.getenv(Metadata.CONFIG_FILE.name());
        System.out.printf("Config file name: %s%n", providedConfigFileName);

        String defaultConfigWithoutPathFileName = new File(DEFAULT_CONFIG_FILE_NAME).getName();
        System.out.printf("Default config file name without path: %s%n", defaultConfigWithoutPathFileName);

        if (null != providedConfigFileName) {
            System.out.printf("Provided config file name '%s'%n", providedConfigFileName);
            File providedConfigFile = new File(providedConfigFileName);
            System.out.printf("Does provided config file name '%s' exists? '%s'%n", providedConfigFileName, providedConfigFile.exists());
            if (providedConfigFile.exists()) {
                configFileToUse = providedConfigFile.getAbsolutePath();
            } else {
                System.out.printf("Provided config file name '%s' does not exist.%n\tCheck file name '%s' in current directory '%s'%n", providedConfigFileName, defaultConfigWithoutPathFileName, WORKING_DIR);
                File defaultConfigWithoutPathFile = new File(defaultConfigWithoutPathFileName);
                System.out.printf("Does file '%s' exists in current directory ('%s')? '%s'%n", defaultConfigWithoutPathFileName, defaultConfigWithoutPathFile.getAbsolutePath(), defaultConfigWithoutPathFile.exists());
                if (defaultConfigWithoutPathFile.exists()) {
                    configFileToUse = defaultConfigWithoutPathFile.getAbsolutePath();
                } else {
                    System.out.printf("Provided config file name '%s' does not exist. File name '%s' does not in current directory '%s'. Check if DEFAULT_CONFIG_FILE_NAME exists'%s' %n",
                            providedConfigFileName, defaultConfigWithoutPathFileName, WORKING_DIR, DEFAULT_CONFIG_FILE_NAME);
                    if (new File(DEFAULT_CONFIG_FILE_NAME).exists()) {
                        System.out.println("Using DEFAULT_CONFIG_FILE_NAME");
                        configFileToUse = new File(DEFAULT_CONFIG_FILE_NAME).getAbsolutePath();
                    } else {
                        throw new InvalidTestDataException("Config file '%s' and DEFAULT_CONFIG_FILE_NAME '%s' does not exist".formatted(providedConfigFile, DEFAULT_CONFIG_FILE_NAME));
                    }
                }
            }
        } else {
            System.out.printf("Provided config file name not provided.%n\tCheck file name '%s' in current directory '%s'%n", defaultConfigWithoutPathFileName, WORKING_DIR);
            File defaultConfigWithoutPathFile = new File(defaultConfigWithoutPathFileName);
            System.out.printf("Does file '%s' exists in current directory ('%s')? '%s'%n", defaultConfigWithoutPathFileName, defaultConfigWithoutPathFile.getAbsolutePath(), defaultConfigWithoutPathFile.exists());
            if (defaultConfigWithoutPathFile.exists()) {
                configFileToUse = defaultConfigWithoutPathFile.getAbsolutePath();
            } else {
                System.out.printf("Provided config file name '%s' does not exist. File name '%s' does not in current directory '%s'. Check if DEFAULT_CONFIG_FILE_NAME exists'%s' %n",
                        providedConfigFileName, defaultConfigWithoutPathFileName, WORKING_DIR, DEFAULT_CONFIG_FILE_NAME);
                if (new File(DEFAULT_CONFIG_FILE_NAME).exists()) {
                    System.out.println("Using DEFAULT_CONFIG_FILE_NAME");
                    configFileToUse = new File(DEFAULT_CONFIG_FILE_NAME).getAbsolutePath();
                } else {
                    throw new InvalidTestDataException("Config file not provided");
                }
            }
        }
        System.out.println("Config file to use: " + configFileToUse);
        return configFileToUse;
    }

    private String getTestDataFileName() {
        String testDataLocalFileName = getOverloadedValueFromPropertiesFor(Metadata.TEST_DATA_FILE_NAME, DEFAULT_TEST_DATA_FILENAME);
        String testDataFileName = testDataLocalFileName;
        if (testDataFileName != null && new File(testDataFileName).exists()) {
            System.out.printf("TEST_DATA_FILE_NAME: %s%n", testDataFileName);
            return testDataFileName;
        } else {
            throw new InvalidTestDataException(String.format("Test data file not provided, or does not exist at '%s': ", testDataFileName));
        }
    }

    @NotNull
    private static Properties loadProperties(String configFile) {
        System.out.printf("Loading properties from %s%n", configFile);
        final Properties properties;
        try (InputStream input = new FileInputStream(configFile)) {
            properties = new Properties();
            properties.load(input);
        } catch (IOException ex) {
            throw new InvalidTestDataException("Config file not found, or unable to read it", ex);
        }
        return properties;
    }

    private static String getHostMachineName() {
        try {
            return InetAddress.getLocalHost().getHostName();
        } catch (UnknownHostException e) {
            System.out.println("Error fetching machine name: " + e.getMessage());
            return NOT_SET;
        }
    }

    @Test
    void runKarateTests() {
        System.out.printf("Class: %s :: Test: runKarateTests%n", this.getClass().getSimpleName());
        List<String> tags = getTags();
        System.setProperty("rp.launch", projectName + " " + testType + " tests");
        System.setProperty("rp.description", projectName + " " + testType + " tests");
        System.setProperty("rp.launch.uuid.print", String.valueOf(Boolean.TRUE));
        System.setProperty("rp.client.join", String.valueOf(Boolean.FALSE));
        System.setProperty("rp.attributes", getRpAttributes());
        Results results = KarateReportPortalRunner
                .path(getClasspath())
                .outputCucumberJson(true)
                .tags(tags)
                .karateEnv(karateEnv)
                .reportDir(reportsDirectory + File.separator + karateReportsDirName)
                .outputCucumberJson(true)
                .outputJunitXml(true)
                .outputHtmlReport(true)
                .parallel(getParallelCount());
        String reportFilePath = generateReport(results.getReportDir());
        String message = "\n\n" + "Test execution summary: ";
        message += "\n\t" + "Tags: " + tags;
        message += "\n\t" + "Environment: " + karateEnv;
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
        testMetadata.put("TargetEnvironment", karateEnv);
        testMetadata.put("Type", testType);
        testMetadata.put("ParallelCount", parallelCount);
        testMetadata.put("LoggedInUser", userName);
        testMetadata.put("JavaVersion", javaVersion);
        testMetadata.put("OS", osName);
        testMetadata.put("HostName", getHostMachineName());
        testMetadata.put("BuildInitiationReason", buildInitiationReason);
        testMetadata.put("BuildId", buildId);
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

    private static String getStringValueFromPropertiesIfAvailable(String key, String defaultValue) {
        return properties.getProperty(key, String.valueOf(defaultValue));
    }

    private String getOverloadedValueFor(Metadata propertyName, String defaultValue) {
        String envVar = getOverriddenStringValue(propertyName.name(), getStringValueFromPropertiesIfAvailable(propertyName.name(), defaultValue));
        return getOverriddenStringValue(envVar, NOT_SET);
    }

    private String getOverloadedValueFromPropertiesFor(Metadata propertyName, String defaultValue) {
        return getOverriddenStringValue(propertyName.name(), getStringValueFromPropertiesIfAvailable(propertyName.name(), defaultValue));
    }

    private boolean getIsRunInCI() {
        return (!buildInitiationReason.equalsIgnoreCase(LOCAL_RUN));
    }

    private String generateReport(String karateOutputPath) {
        System.out.println("================================================================================================");
        System.out.println("===================================  Generating reports  =======================================");
        System.out.println("================================================================================================");
        java.util.Collection<java.io.File> jsonFiles = org.apache.commons.io.FileUtils.listFiles(new java.io.File(karateOutputPath), new String[]{"json"}, true);
        String reportFilePath = null;
        if (jsonFiles.size() == 0) {
            throw new InvalidTestDataException("Reports NOT generated. Have you provided the correct configuration/tags for execution?");
        } else {
            java.util.List<String> jsonPaths = new java.util.ArrayList<>(jsonFiles.size());
            jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
            net.masterthought.cucumber.Configuration config = new net.masterthought.cucumber.Configuration(new File(getPath(reportsDirectory, cucumberReportsDirName)), projectName);

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
            reportFilePath = config.getReportDirectory().getAbsolutePath() + cucumberReportsFileName;
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

    private void loadEnvConfig() {
        String testDataFilePath = getPath(WORKING_DIR, testDataFile);
        System.out.println("Test Data file path: " + testDataFilePath);
        try {
            testDataConfig = JsonPath.parse(new File(testDataFilePath)).read("$", Map.class);
            envConfig = JsonPath.parse(testDataConfig).read("$." + karateEnv + ".env", Map.class);
        } catch (IOException e) {
            throw new InvalidTestDataException(String.format("Unable to load test data file: '%s'", testDataFile), e);
        }
    }

    private static String getCurrentDatestamp(Date today) {
        SimpleDateFormat df = new SimpleDateFormat("dd-MMM-yyyy");
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
        String reportsDirPath = NOT_SET;
        if (null == System.getenv(LOG_DIR)) {
            Date today = new Date();
            reportsDirPath = getPath(WORKING_DIR,
                    "target" + File.separator
                            + getMonth(today) + File.separator
                            + getCurrentDatestamp(today) + File.separator
                            + getCurrentTimestamp(today));
        } else {
            reportsDirPath = System.getenv(LOG_DIR);
        }
        System.out.println("Reports directory: " + reportsDirPath);
        return reportsDirPath;
    }

    private String getTargetEnvironment() {
        String karateEnv = OverriddenVariable.getOverriddenStringValue(Metadata.TARGET_ENVIRONMENT.name(), properties.getProperty(Metadata.TARGET_ENVIRONMENT.name()));
        if ((null == karateEnv) || (karateEnv.isBlank())) {
            String message = "TARGET_ENVIRONMENT is not specified as an environment variable";
            System.out.println(message);
            throw new InvalidTestDataException(message);
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
        String env = karateEnv;
        String envTag = ((null != env) && (!env.trim().isEmpty())) ? env.toLowerCase() : "@prod";
        if (!envTag.startsWith("@")) {
            envTag = "@" + envTag;
        }
        System.out.println("Run tests on environment: " + envTag);
        return envTag;
    }

    private String getClasspath() {
        System.out.println("In " + this.getClass().getSimpleName() + " :: getClassPath");
        String type = testType;
        String classPath = "classpath:com/znsio/" + type;
        System.out.printf("Running %s tests%n", classPath);
        return classPath;
    }

    private int getParallelCount() {
        String parallel = OverriddenVariable.getOverriddenStringValue(Metadata.PARALLEL_COUNT.name(), properties.getProperty(Metadata.PARALLEL_COUNT.name()));
        int parallelCount = (null == parallel || parallel.isEmpty()) ? 5 : Integer.parseInt(parallel);
        System.out.printf("Parallel count: %d %n", parallelCount);
        return parallelCount;
    }
}
