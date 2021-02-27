// Define the declarative pipeline stages
pipeline {
    options {
        // Retain only the last 5 builds on master, and only the most recent
        //  build on any other branch.
        // https://issues.jenkins-ci.org/browse/JENKINS-47717
        buildDiscarder(logRotator(
            // number of builds to keep the logs from
            numToKeepStr:         env.BRANCH_NAME ==~ /master/ ? "${config.jenkins.logsToKeep.master}" : "${config.jenkins.logsToKeep.branches}",
            // number of builds to keep the artifacts from
            artifactNumToKeepStr: env.BRANCH_NAME ==~ /master/ ? "${config.jenkins.buildsToKeep.master}" : "${config.jenkins.buildsToKeep.branches}"
        ))

        // Only one build can run at a time
        disableConcurrentBuilds()

        // Save only the stashes from the most recent build
        preserveStashes()
    }
}
