pipeline {
    stage("TEST") {
        // https://jenkins.io/doc/book/pipeline/jenkinsfile/#handling-credentials
        environment {
            AWS_REGION            = credentials('jenkins-aws-region')
            AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-access-key-id')
            AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
        }
    }
}
