pipeline{
    agent{
        label 'AGENT-1'
    }

    options{
        timeout(time: 15, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    stages{
        stage('Init'){
            steps{
                sh '''
                    cd 001-vpc/
                    terraform init --reconfigure
                '''
            }
        }
        stage('Plan'){
            steps{
                sh '''
                    cd 001-vpc/
                    terraform plan
                '''
            }
        }
        stage('Apply'){
            steps{
                sh '''
                    cd 001-vpc/
                    terraform apply -auto-approve
                '''
            }
        }
        stage('Destroy'){
            steps{
                sh '''
                    cd 001-vpc/
                    terraform destroy -auto-approve
                '''
            }
        }
    }
    
    post{
        always{
            deleteDir()
        }
        success{
            echo "I will run when pipeline is success"
        }
        failure{
            echo "I will run when pipeline is failure"
        }
    }
}