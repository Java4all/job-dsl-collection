BASE_STEPS = '''#!/bin/bash
echo Hello World!
pwd
kubectl get pods
'''

job('PublishDemoApp') {
    //name 'Publish-Python-Demo-App'
    //description 'Python Demo App- Publish'
    label ('swarm')
    parameters {
        credentialsParam('KUBECONF') {
            type('org.jenkinsci.plugins.plaincredentials.impl.FileCredentialsImpl')
            required()
            defaultValue('gke-gre3-01-usercluster02-kubeconfig')
            description('Key for deploying build artifacts')
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
        shell(BASE_STEPS)
    }
    //publishers {
    //    archiveJunit('target/*.xml')
    //}
}
