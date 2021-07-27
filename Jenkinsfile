@Library(value = 'utilities')_
import hudson.Util;

pipeline {
  agent {
    kubernetes {
    // There are different builder available, Please refer https://confluence.elcompanies.net/display/SRED/SRE+Jenkins+Builder
      label 'jnlp-mvn-builder'
      defaultContainer 'builder'
    }
  }
  parameters {
    // GIT repository URI in form project/repo.git only
    //string(name: 'git_repo_source', defaultValue: 'gblstar/sample-maven-app.git', description: 'Git repository. Mention in the form project/repo.git only. No need to include the complete repo URL')
	  
    // Default branch name to build project
    //string(name: 'git_repo_branch', defaultValue: 'development', description: 'Source Repo branch to be checked out')
	  
    // Application name in IQ Server, for e.g, elc-sample-maven-app
    string(name: 'iq_server_application', defaultValue: 'dr-sample-maven-app', description: 'Application name at IQ Server')
	  
    // Enable/Disable Nexus IQ Policy evaluation (Yes, Recommended)
    string(name: 'invoke_Nexus_Policy_Evaluation', defaultValue: 'Yes', description: 'Perform Nexus Scan (Yes/No)')
	  
    // Project Build type
    choice(name: 'projectType', choices: 'maven', description: 'Select Project Type')

    // Path for application image for e.g, elc/<project-name>/middleware/<project-name>-mw
    string(name: 'docker_repository', defaultValue: 'elc/rig/samplemaven', description: 'The docker repository')
  }
  options {
    disableConcurrentBuilds()
    buildDiscarder(logRotator(daysToKeepStr: '7', artifactDaysToKeepStr: '7'))
    timeout(time: 1, unit: 'HOURS')
    skipDefaultCheckout()
  }

  // This method is used, when you want to automatically trigger your jenkins job after bitbucket commit
  triggers{
      bitbucketPush()
  }
  stages {
    // This stage is used for Cloning Git Repo
    stage('Checkout git repo') {
 			steps {
        // For more information on this Jenkins plugin you can visit following confluence age
        // Confluence page: https://confluence.elcompanies.net/display/SRED/gitCheckoutHttps
		//	  gitCheckoutHttps()
			gitCheckoutHttps git_repo_source: 'drc/samplemaven.git', git_repo_branch: 'master', is_source_code_repo: "true"
    	}
	  }

    //This stage is used to build the project
    stage('Build') {
		  steps {
			  sh "echo Packaging Sample MiddleWare Application"
			  sh "mvn clean package"
		  }
    }

    // This stage is used to do Sonar check and generate scan report. You can refer the sonar scan report in Jenkins Job.
		stage('SonarQube Analysis-Shared') {
      steps {
				script {
          executeSonarQubeCheck()
        }            
			}
    }

    //This stage is used for Nexus IQ Scanning. You can refer the Nexus IQ scan report in Jenkins Job.
		stage('Nexus IQ Scan') {
			steps {
				nexusPolicyEvaluationWrapper()
			}
		}

    //This stage is used for upload the build and dependencies to Nexus Repo 
		stage('Nexus Repo Upload') {
      steps {
        nexusUploadMaven()
      }
    }

    // This stage is used for below two purposes.
    // 1. To build and push the docker image to Azure container registry
    // 2. For Aqua container security scanning and reports and be seen in Jenkins Job. (Need to resolve Aquasec reported issues as per ELC security Guideline). 
    stage('Push Docker image to Azure Container Registry') {
      steps {
       buildAndPushToAzureRegistry docker_tag_prefix: 'prefix', docker_tag_suffix: 'suffix', docker_build_arg: "prodimage_tag=prod projectName=noob",
        targetACRResourceId: "AM-PROD-SHARED-ACR-RESCOURCE-ID", targetACRSPNCredsId: "AM-PROD-SHARED-ACR-SPM",acrTaskBuildTimeoutInSeconds: "180"
      }
	}
  }	        
}
