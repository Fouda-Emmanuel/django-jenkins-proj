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

        stage('Prepare Environment File') {
            steps {
                echo '📝 Copying Django env file to workspace...'
                withCredentials([file(credentialsId: 'django-env-file', variable: 'ENV_FILE')]) {
                    sh 'cp $ENV_FILE .env'
                }
            }
        }

        stage('Run Django Checks') {
            steps {
                echo '⚙️ Running Django system checks inside container...'
                sh 'docker exec -i django_jenkins_proj-web-1 python manage.py check'
            }
        }

        stage('Run Tests with Coverage') {
            steps {
                echo '🧪 Running tests inside container with coverage...'
                sh '''
                    docker exec -i django_jenkins_proj-web-1 sh -c "
                        export COVERAGE_FILE=/tmp/.coverage && \
                        pytest --junitxml=/tmp/test-results.xml \
                               --cov=./ --cov-report=xml:/tmp/coverage.xml
                    "

                    docker cp django_jenkins_proj-web-1:/tmp/test-results.xml .
                    docker cp django_jenkins_proj-web-1:/tmp/coverage.xml .
                '''
            }
            post {
                always {
                    echo '📄 Archiving test results and coverage report...'
                    junit 'test-results.xml'
                    archiveArtifacts 'coverage.xml'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo '🔍 Sending code analysis to SonarQube...'
                withSonarQubeEnv('sonarqube-server') {
                    sh '''
                        sonar-scanner \
                          -Dsonar.projectKey=django_jobportal \
                          -Dsonar.sources=. \
                          -Dsonar.host.url=http://localhost:9002 \
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
