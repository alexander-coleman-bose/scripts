#!/user/bin/env groovy

// Read the YAML pipeline configuration and make it available to all stages
// https://stackoverflow.com/questions/46751117/jenkins-pipeline-read-from-yaml
node {
    checkout scm
    config = readYaml file: 'jenkins.yml'
}

pipeline {
    stage('PRINT') {
        steps {
            sh "echo config.repo.name: ${config.repo.name}"
        }
    }
}
