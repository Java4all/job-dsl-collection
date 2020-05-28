BASE_STEPS = '''#!/bin/bash
sudo chmod 755 /bin/kubectl
export https_proxy='http://192.168.255.12:8080/'
export http_proxy='http://192.168.255.12:8080/'
export no_proxy='http://172.16.13.123/,.jcasc.svc.cluster.local,10.245.0.0/16'
kubectl --kubeconfig=$HOME/kubeconf get pods
kubectl --kubeconfig=$HOME/kubeconf  delete -f ./gke-demoapp-deployment.yaml
kubectl --kubeconfig=$HOME/kubeconf  delete -f ./gke-demoapp-service.yaml

kubectl --kubeconfig=$HOME/kubeconf  apply -f ./gke-demoapp-service.yaml
kubectl --kubeconfig=$HOME/kubeconf  apply -f ./gke-demoapp-deployment.yaml

'''

job('PublishDemoApp') {
    //name 'Publish-Python-Demo-App'
    //description 'Python Demo App- Publish'
    label ('swarm')

    wrappers {
     credentialsBinding {
       file('KUBECONFVAR','KUBECONF')
     }
     colorizeOutput()
     timestamps()
  }

    scm {
      git {
        remote { 
            url ('https://gitlab.com/elesvi1/python-flask-jen.git')
            credentials('gitlabuser')
               }
          branch '*/master'
          extensions {}
        }
      }
    triggers {
        scm('*/2 * * * *')
    }
    
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
