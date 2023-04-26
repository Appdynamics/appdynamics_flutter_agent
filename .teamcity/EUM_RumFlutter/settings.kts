package EUM_RumFlutter

import com.appdynamics.build.teamcity.pipelib.*

AppdBuildSettings.Builder(AppdBuild.PipeLibType.JAVA_LIB)
        .teamcityParent("EUM")
        .bitbucketProject("eum")
        .repo("rum-flutter")
        .projectID("EUM_RumFlutter")
        .testTargets(":example:runInstallationTest", ":example:runIntegrationTestsAndroid", ":example:runIntegrationTestsiOS")
        .buildTargets("build", "upgradeFlutter", "installPackages", "analyze", "runUnitTests", "buildAndroid", "buildiOS", "generateDocs")
        .simpleParams("env.JAVA_HOME" to "/Library/Java/JavaVirtualMachines/jdk-17.0.2.jdk/Contents/Home")
        .passwordParams()
        .checkboxParams()
        .selectParams()
        .projectName("Flutter Agent")
        .deploy(true)
        .agentType("BigSur")
        .build()
