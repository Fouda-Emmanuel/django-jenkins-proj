pipeline {
    agent any

    environment {
        DJANGO_SETTINGS_MODULE = 'talent_base.settings'
        SONARQUBE = credentials('sonarqube-jenkins-token')
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo '🚀 Checking out code from GitHub...'
                git(
                    url: 'https://github.com/Fouda-Emmanuel/django-jenkins-proj.git',
                    credentialsId: 'github-username-pwd',
                    branch: 'main'
                )
            }
        }

        stage('Run Django Checks') {
            steps {
                echo '⚙️ Running Django system checks in Docker...'
                sh 'docker compose -f deploy.yml run --rm web python manage.py check'
            }
        }

        stage('Run Tests with Coverage') {
            steps {
                echo '🧪 Running tests inside Docker...'
                sh '''
                    docker compose -f deploy.yml run --rm web \
                    pytest -v -rA --cov=. --cov-report=xml --junitxml=test-results.xml
                '''
            }
            post {
                always {
                    junit 'test-results.xml'
                    archiveArtifacts 'coverage.xml'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo '🔍 Sending code analysis to SonarQube...'
                withSonarQubeEnv('sonarqube') {
                    sh '''
                        sonar-scanner \
                          -Dsonar.projectKey=django_jobportal \
                          -Dsonar.sources=. \
                          -Dsonar.host.url=http://localhost:9001 \
                          -Dsonar.login=$SONARQUBE \
                          -Dsonar.python.version=3.10 \
                          -Dsonar.python.coverage.reportPaths=coverage.xml \
                          -Dsonar.tests=accounts/tests,application_tracking/tests \
                          -Dsonar.test.inclusions=**/test_*.py \
                          -Dsonar.exclusions=**/__pycache__/**,**/migrations/**,**/venv/**,**/static/**,**/media/**,**/screenshots/**,**/templates/**
                    '''
                }
            }
        }

    }

    post {
        success {
            echo '🎉 SUCCESS: Tests + SonarQube analysis completed!'
        }
        failure {
            echo '❌ FAILURE: Something went wrong in the pipeline!'
        }
    }
}
