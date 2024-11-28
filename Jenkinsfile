@Library('GTSO-CI-Jenkins-Library@master') _


environment {
     packageJSON = readJSON file: 'package.json'
     ARTIFACT_VERSION = packageJSON.version
     echo "Artifact Version is: ${ARTIFACT_VERSION}"
     ARTIFACT_VERSION_WITH_BUILD_NUM = $ARTIFACT_VERSION-$BUILD_NUMBER
     echo "Artifact Version with Build Number: ${ARTIFACT_VERSION_WITH_BUILD_NUM}"

}

node("slave-container-2") {
    def config = [
            build_config: "resources/build-info.yaml",
            integration_branch: "test",
            snapshot_branch : "feat*",
            verify_branch: "verify*",
            prod_branch: "prod*",
            deployment_configs: "deployment",
            jenkins_node_label: "slave-container-2",
            //jenkins_node_label: "sbo-portal-core-dev",
            prod_promotion_source: "integration_branch", 
            run_integration_tests: false,
            secure_executions: false 
    ]
    sboPipeline(this, config)
}
