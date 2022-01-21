package EUM_RumFlutter

import com.appdynamics.build.teamcity.pipelib.*

AppdBuildSettings.Builder(AppdBuild.PipeLibType.JAVA_LIB)
    .teamcityParent("EUM")
    .bitbucketProject("eum")
    .repo("rum-flutter")
    .projectID("EUM_RumFlutter")
    .testTargets()
    .buildTargets(
        "build",
        "downloadFlutter",
        "installPackages",
        "analyze",
        "runUnitTests",
        ":example:buildAndroid",
        "generateDocs"
    )
    .passwordParams()
    .checkboxParams()
    .agentType("MacOS")
    .selectParams()
    .projectName("Flutter Agent")
    .build()
