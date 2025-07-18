package EUM_RumFlutter

import com.appdynamics.build.teamcity.pipelib.*

AppdBuildSettings.Builder(AppdBuild.PipeLibType.JAVA_LIB)
        .teamcityParent("EUM")
        .bitbucketProject("eum")
        .repo("rum-flutter")
        .projectID("EUM_RumFlutter")
        .testTargets(":example:runInstallationTest", ":example:runIntegrationTestsAndroid", ":example:runIntegrationTestsiOS")
        .buildTargets("build", "upgradeFlutter", "installPackages", "analyze", "runUnitTests", "buildAndroid", "buildiOS", "generateDocs")
        .simpleParams("env.MD_APPLE_SDK_ROOT" to "/Applications/Xcode-15.2.app/","env.SONAR_HOST_URL" to "%env.SONAR_BARE_HOST_URL%", "env.SONAR_LOGIN" to "%env.SONAR_BARE_LOGIN%", "env.JAVA_HOME" to "/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home")
        .passwordParams()
        .checkboxParams()
        .selectParams()
        .projectName("Flutter Agent")
        .deploy(true)
        .agentType("Ventura-M1")
        .build()
