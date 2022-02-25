package EUM_RumFlutter

import com.appdynamics.build.teamcity.pipelib.*

AppdBuildSettings.Builder(AppdBuild.PipeLibType.JAVA_LIB)
    .teamcityParent("EUM")
    .bitbucketProject("eum")
    .repo("rum-flutter")
    .projectID("EUM_RumFlutter")
    .buildTargets(
        "build",
        "upgradeFlutter",
        "analyze",
        "runUnitTests,
        "buildAndroid",
        "buildiOS",
        ":example:runIntegrationTestsAndroid"
        ":example:runIntegrationTestsiOS",
        "generateDocs"
    )
    .simpleParams()
    .passwordParams()
    .checkboxParams()
    .agentType("BigSur")
    .selectParams()
    .projectName("Flutter Agent")
    .build()
