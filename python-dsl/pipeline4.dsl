BASE_STEPS = '''#!/bin/bash
sudo chmod 755 /bin/kubectl
export https_proxy='http://192.168.255.12:8080/'
export http_proxy='http://192.168.255.12:8080/'
export no_proxy='http://172.16.13.123/,.jcasc.svc.cluster.local,10.245.0.0/16'

### working directory
cd ./terra

### terraform init
terraform init
### terraform plan
terraform plan
### terraform destroy
terraform destroy -auto-approve

'''

job('Create Google Bucket over Terraform') {
    label ('swarm')
    
    logRotator {
    numToKeep(50)
    artifactNumToKeep(50)
    }

    steps {
        shell(BASE_STEPS)
    }
    //publishers {
    //    archiveJunit('target/*.xml')
    //}
}
