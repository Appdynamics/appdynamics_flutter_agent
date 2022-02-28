package EUM_RumFlutter

import com.appdynamics.build.teamcity.pipelib.*

AppdBuildSettings.Builder(AppdBuild.PipeLibType.JAVA_LIB)
    .teamcityParent("EUM")
    .bitbucketProject("eum")
    .repo("rum-flutter")
    .projectID("EUM_RumFlutter")
    .testTargets(
        ":example:runIntegrationTestsAndroid",
        ":example:runIntegrationTestsiOS"
    )
    .buildTargets(
        "build",
        "upgradeFlutter",
        "installPackages",
        "analyze",
        "runUnitTests",
        "buildAndroid",
        "buildiOS",
        "generateDocs"
    )
    .simpleParams()
    .passwordParams()
    .checkboxParams()
    .agentType("BigSur")
    .selectParams()
    .projectName("Flutter Agent")
    .build()
