pipeline {
  agent {
    node {
      label 'Mineral'
      customWorkspace "workspace/${JOB_NAME}/${BUILD_NUMBER}"
    }
  }
  tools {
    nodejs 'node'
  }
  options {
    ansiColor('xterm')
  }
  environment {
    PREVIEW_PATH = "${BUILD_URL.replace(JENKINS_URL, '/')}preview/"
    PREVIEW_URL = "${BUILD_URL}preview/index.html"
    GH_REPO_NAME = 'ESD/mineral-cra-starter'
    GH_PAGES_PATH = "/pages/${GH_REPO_NAME}/"
    GH_TOKEN = credentials('GH_TOKEN') // GitHub personal access token with repo permissions
  }
  stages {
    stage('Install Dependencies') {
      steps {
        sh 'yarn install --frozen-lockfile --non-interactive'
      }
    }
    stage('Verify') {
      parallel {
        stage('Checks') {
          steps {
            sh 'yarn checks'
          }
        }
        stage('Test') {
          steps {
            sh 'yarn test:ci'
          }
        }
      }
    }
    stage('Deploy Preview') {
      when { changeRequest(); }
      steps {
        script {
          try {
            pullRequest.createStatus(
              status: 'pending',
              context: 'Deploy Preview',
              description: 'The preview is being built')
            sh "PUBLIC_URL=${PREVIEW_PATH} yarn build"
            publishHTML ([
              allowMissing: false,
              alwaysLinkToLastBuild: true,
              keepAll: true,
              reportDir: 'build',
              reportFiles: 'index.html',
              reportName: 'preview',
              reportTitles: ''
            ])
            pullRequest.createStatus(
              status: 'success',
              context: 'Deploy Preview',
              description: 'The preview built successfully',
              targetUrl: PREVIEW_URL)
          } catch (err) {
            pullRequest.createStatus(
              status: 'failure',
              context: 'Deploy Preview',
              description: 'The preview failed to build')
            throw err
          }
        }
      }
    }
    stage('GitHub Pages') {
      when { branch 'master' }
      steps {
        sh "PUBLIC_URL=${GH_PAGES_PATH} yarn build"
        sh 'yarn gh-pages -d build'
      }
    }
  }
  post {
    cleanup {
      cleanWs()
    }
  }
}

