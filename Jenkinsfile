pipeline {
    agent any
    
    stages {
        stage('Checkout Code') {
            steps {
                echo 'Starting pipeline...'
                git(
                    url: 'https://github.com/Fouda-Emmanuel/django-jenkins-proj.git',
                    credentialsId: 'github-jenkins-token',
                    branch: 'main'
                )
                echo 'Code checkout completed!'
            }
        }
        
        stage('List Files') {
            steps {
                echo 'Listing project files:'
                sh 'ls -la'
            }
        }
        
        stage('Test Python') {
            steps {
                echo 'Testing Python installation:'
                sh 'python3 --version'
                sh 'pip --version'
            }
        }
        
        stage('Simple Test') {
            steps {
                echo 'Running a simple test...'
                sh 'echo "This is a test step from Jenkins!"'
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed!'
        }
        success {
            echo 'SUCCESS: Webhook test worked!'
        }
        failure {
            echo 'FAILED: Something went wrong.'
        }
    }
}