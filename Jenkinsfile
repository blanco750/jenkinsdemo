// Jenkinsfile
String credentialsId = 'awsCredentials'

try {
    stage('checkout') {
    node {
        cleanWs()
        checkout scm
    }
    }

  // Run terraform init
    stage('terrafom init') {
        node {
            withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: credentialsId,
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]]) {
            ansiColor('xterm') {
                dir ('environments/dev') {
                    sh 'terraform init'
                    sh 'echo "This is $(pwd)"'
                    sh 'ls -lrt'
                }

                }
            }
            }
    }
  // Run terraform validate

    stage('terraform Validate'){
            node {
            withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: credentialsId,
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]]) {
            ansiColor('xterm') {
                dir ('environments/dev') {
                    sh 'terraform validate'
                }
            }
            }
        }
        }

  // Run terraform plan
    stage('terraform plan') {
        node {
            withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: credentialsId,
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]]) {
            ansiColor('xterm') {
                dir ('environments/dev') {
                    sh 'terraform plan'
                }
            }
            }
        }
        }

    //Manual approval step
    if (env.BRANCH_NAME == 'master') {
        stage('Manual approval before tf apply') {
            timeout(time: 3, unit: 'HOURS') {
                node {
                    withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: credentialsId,
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]]) {
                    ansiColor('xterm') {
                        input 'approve the plan to proceed and apply'
            }
        }
                }
                }
        }
    }




    if (env.BRANCH_NAME == 'master') {

        // Run terraform apply
        stage('terraform apply') {
            node {
                withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: credentialsId,
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                ansiColor('xterm') {
                        script{
                            def apply = false
                            try {
                                input message: 'Can you please confirm the apply', ok: 'Ready to Apply the Config'
                                apply = true
                            } catch (err) {
                                apply = false
                                currentBuild.result = 'UNSTABLE'
                            }
                            if(apply){
                                dir ('environments/dev') {
                                    sh 'terraform apply -auto-approve'
                    }
                }
                }
            }
            }
            }
        }
    }

    //Run terraform show
    stage('terraform show') {
        node {
            withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: credentialsId,
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]]) {
            ansiColor('xterm') {
                dir ('environments/dev') {
                    sh 'terraform show'
                }
            }
            }
        }
        }

    //Deploy the demoapp to the EKS Fargate cluster.

    if (env.BRANCH_NAME == 'master') {

        stage('DemoAPP Deploy-DONT FORGET VPC ID CHANGE') {
            node {
                withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: credentialsId,
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                ansiColor('xterm') {
                        script{
                            def deploy = false
                            try {
                                input message: '(FIRST CHANGE VPC ID IN ALB INGRESS CONTROLLER DEPLOYMNET FILE)Would you like to deploy the app on EKS Fargate', ok: 'Deploy the app on the eks cluster'
                                deploy = true
                            } catch (err) {
                                deploy = false
                                currentBuild.result = 'UNSTABLE'
                            }
                            if(deploy){
                                sh 'kubectl apply -f demoapp/operators/external-secret.yaml'
                                sh 'kubectl apply -f demoapp/operators/alb-ingress-controller.yaml'
                                sh 'kubectl apply -f demoapp/operators/webapp-deployment.yaml'
                                sh 'kubectl apply -f demoapp/operators/nginx-service.yaml'
                                sh 'kubectl apply -f demoapp/operators/nginx-ingress.yaml'
                                sh 'kubectl get pod'
                }
                }
            }
            }
            }
        }
    }


    //Destroy the Cluster and resources after demo complete.
    if (env.BRANCH_NAME == 'master') {

        stage('TF Destroy-MANUALLY DELETE THE ALB AND ASSOCIATED TG') {
            node {
                withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: credentialsId,
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                ansiColor('xterm') {
                        script{
                            def destroy = false
                            try {
                                input message: 'Would you like to Destroy your cluster', ok: 'Destroy the TF EKS Resources'
                                destroy = true
                            } catch (err) {
                                destroy = false
                                currentBuild.result = 'UNSTABLE'
                            }
                            if(destroy){
                                dir ('environments/dev') {
                                    sh 'kubectl delete -f ../../demoapp/operators/alb-ingress-controller.yaml'
                                    sh 'kubectl delete -f ../../demoapp/operators/webapp-deployment.yaml'
                                    sh 'kubectl delete -f ../../demoapp/operators/nginx-service.yaml'
                                    sh 'kubectl delete -f ../../demoapp/operators/nginx-ingress.yaml'
                                    sh 'terraform destroy -auto-approve'
                }
                }
                }
            }
            }
            }
        }
    }

currentBuild.result = 'SUCCESS'
}
catch (org.jenkinsci.plugins.workflow.steps.FlowInterruptedException flowError) {
    currentBuild.result = 'ABORTED'
}
catch (err) {
    currentBuild.result = 'FAILURE'
    throw err
    }
finally {
    if (currentBuild.result == 'SUCCESS') {
    currentBuild.result = 'SUCCESS'
    }
}