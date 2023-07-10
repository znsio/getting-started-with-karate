package com.znsio.reportPortal;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;
import org.apache.log4j.Logger;

public class SessionContext {
    private static final Logger LOGGER = Logger.getLogger(SessionContext.class.getName());
    private static final Properties reportPortalProperties;
    private static String reportPortalLaunchURL = "";

    static {
        LOGGER.info("SessionContext default constructor");
        new SessionContext();
        reportPortalProperties = loadReportPortalProperties();
        LOGGER.info("Initialized SessionContext");
    }

    public static Properties loadReportPortalProperties() {
        Properties properties = new Properties();

        try {
            String reportPortalPropertiesFile = "src/test/resources/reportportal.properties";
            LOGGER.info("Using reportportal.properties file from " + reportPortalPropertiesFile);
            File reportPortalFile = new File(reportPortalPropertiesFile);
            String absolutePath = reportPortalFile.getAbsolutePath();
            if (reportPortalFile.exists()) {
                properties.load(new FileInputStream(absolutePath));
                LOGGER.info("Loaded reportportal.properties file - " + absolutePath);
            } else {
                LOGGER.info("reportportal.properties file NOT FOUND - " + absolutePath);
            }

            return properties;
        } catch (IOException var4) {
            LOGGER.info("ERROR in loading reportportal.properties file\n" + var4.getMessage());
            throw new RuntimeException(var4.getMessage());
        }
    }
    public static void setReportPortalLaunchURL() {
        boolean isReportPortalEnabledInProperties = null == reportPortalProperties.getProperty("rp.enable") || reportPortalProperties.getProperty("rp.enable").equalsIgnoreCase("true");
        if (isReportPortalEnabledInProperties) {
            String rpLaunchId = System.getProperty("rp.launch.id");
            LOGGER.debug(String.format("System property: rp.launch.id: '%s'", rpLaunchId));
            reportPortalLaunchURL = String.format("%s/ui/#%s/launches/all/%s", reportPortalProperties.getProperty("rp.endpoint"), reportPortalProperties.getProperty("rp.project"), rpLaunchId);
            return ;
        }
         reportPortalLaunchURL="Report Portal is not enabled in reportportal.properties";

    }
    public static String getReportPortalLaunchURL(){
        setReportPortalLaunchURL();
        return reportPortalLaunchURL;
    }
}

