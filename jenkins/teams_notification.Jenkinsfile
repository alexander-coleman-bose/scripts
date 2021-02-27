node {
    checkout scm
    commit_stub = sh (
        returnStdout: true,
        script: "git log --oneline --format=%h -n 1 HEAD | tr -d '\n'"
    )
    commit_message = sh (
        returnStdout: true,
        script: "git log --oneline --format=%B -n 1 HEAD | tr -d '\n'"
    )
}

pipeline {
    // Send Pipeline Success/Failure to Teams if main fails.
    post {
        failure {
            script {
                if ("${env.BRANCH_NAME}" == 'main') {
                    office365ConnectorSend color: "E76F51",
                        message: "Commit (${commit_stub}): ${commit_message}",
                        status: "FAILED",
                        webhookUrl: "${config.jenkins.office365Webhook}"
                }
            }
        }
    }
} // Pipeline
