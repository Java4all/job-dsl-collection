BASE_STEPS = '''#!/bin/bash
echo Hello World!
pwd
kubectl get pods
'''

job('PublishDemoApp') {
    //name 'Publish-Python-Demo-App'
    //description 'Python Demo App- Publish'
    label ('swarm')

    wrappers {
     credentialsBinding {
       file('gke-gre3-01-usercluster02-kubeconfig', 'KUBECONF')
     }
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
        shell('pwd'+
        'echo $KUBECONF')
    }
    //publishers {
    //    archiveJunit('target/*.xml')
    //}
}
