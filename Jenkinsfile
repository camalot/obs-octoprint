#!groovy
import com.bit13.jenkins.*

if(env.BRANCH_NAME ==~ /master$/) {
		return
}


node ("node") {
	def ProjectName = "obs-octoprint"
	def slack_notify_channel = null
	def MAJOR_VERSION = 1
	def MINOR_VERSION = 0


	properties ([
		buildDiscarder(logRotator(numToKeepStr: '25', artifactNumToKeepStr: '25')),
		disableConcurrentBuilds(),
		pipelineTriggers([
			pollSCM('H/30 * * * *')
		]),
	])

	env.PROJECT_MAJOR_VERSION = MAJOR_VERSION
	env.PROJECT_MINOR_VERSION = MINOR_VERSION

	env.CI_BUILD_VERSION = Branch.getSemanticVersion(this)
	env.CI_DOCKER_ORGANIZATION = Accounts.GIT_ORGANIZATION
	env.CI_PROJECT_NAME = ProjectName
	currentBuild.result = "SUCCESS"

	def errorMessage = null
	wrap([$class: 'TimestamperBuildWrapper']) {
		wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
			Notify.slack(this, "STARTED", null, slack_notify_channel)
			try {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: env.CI_DOCKER_HUB_CREDENTIAL_ID,
								usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD']]) {

					withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: env.CI_ARTIFACTORY_CREDENTIAL_ID,
													usernameVariable: 'ARTIFACTORY_USERNAME', passwordVariable: 'ARTIFACTORY_PASSWORD']]) {
						stage ("install" ) {
							env.OCTOPRINT_API_KEY = SecretsVault.get(this, "secret/${env.CI_PROJECT_NAME}", "OCTOPRINT_API_KEY")
							env.OCTOPRINT_HOST = SecretsVault.get(this, "secret/${env.CI_PROJECT_NAME}", "OCTOPRINT_HOST")
							env.OCTOPRINT_PORT = SecretsVault.get(this, "secret/${env.CI_PROJECT_NAME}", "OCTOPRINT_PORT")

							deleteDir()
							Branch.checkout(this, env.CI_PROJECT_NAME)
							Pipeline.install(this)
							Node.createAuthenticationFile(this, env.CI_DOCKER_ORGANIZATION)

						}
						stage ("lint") {
							sh script: "${WORKSPACE}/.deploy/lint.sh -n '${env.CI_PROJECT_NAME}' -v '${env.CI_BUILD_VERSION}' -o '${env.CI_DOCKER_ORGANIZATION}'"
						}
						stage ("build") {
							sh script: "${WORKSPACE}/.deploy/build.sh -n '${env.CI_PROJECT_NAME}' -v '${env.CI_BUILD_VERSION}' -o '${env.CI_DOCKER_ORGANIZATION}'"
						}
						stage ("test") {
							sh script: "${WORKSPACE}/.deploy/test.sh -n '${env.CI_PROJECT_NAME}' -v '${env.CI_BUILD_VERSION}' -o '${env.CI_DOCKER_ORGANIZATION}'"
						}
						stage ("deploy") {
							sh script: "${WORKSPACE}/.deploy/deploy.sh -n '${env.CI_PROJECT_NAME}' -v '${env.CI_BUILD_VERSION}' -o '${env.CI_DOCKER_ORGANIZATION}'"
						}
						stage ('publish') {
							sh script:  "${WORKSPACE}/.deploy/validate.sh -n '${env.CI_PROJECT_NAME}' -v '${env.CI_BUILD_VERSION}' -o '${env.CI_DOCKER_ORGANIZATION}'"

							Branch.publish_to_master(this)
							Pipeline.publish_buildInfo(this)
						}
						stage ('run') {
							sh script:  "${WORKSPACE}/.deploy/run.sh -n '${env.CI_PROJECT_NAME}' -v '${env.CI_BUILD_VERSION}' -o '${env.CI_DOCKER_ORGANIZATION}' -f"
						}
					}
				}
			} catch(err) {
				currentBuild.result = "FAILURE"
				errorMessage = err.message
				throw err
			}
			finally {
				Pipeline.finish(this, currentBuild.result, errorMessage)
			}
		}
	}
}
