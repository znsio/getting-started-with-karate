# Project specific customisations

Update the following values in RunTest.java to make it contextual to your project:

    // environment variable that indicates if build was manually triggrerd, or auto-triggered
    private static final String BUILD_INITIATION_REASON = "BUILD_INITIATION_REASON";

    // environment variable that has the id for the build
    private static final String BUILD_ID = "BUILD_ID";

    // name of your project/team/repo
    private final String PROJECT_NAME = "getting-started-with-karate";
