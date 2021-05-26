package Eum_RumFlutter

import com.appdynamics.build.teamcity.pipelib.*

AppdBuildSettings.Builder(AppdBuild.PipeLibType.JAVA_LIB)
        .teamcityParent("Eum")
        .bitbucketProject("eum")
        .repo("rum-flutter")
        .projectID("Eum_RumFlutter")
        .testTargets()
        .buildTargets("build")
        .simpleParams()
        .passwordParams()
        .checkboxParams()
        .selectParams()
        .projectName("Eum_RumFlutter")
        .build()
