BASE_STEPS = '''#!/bin/bash
echo Hello World!
pwd
kubectl get pods
'''

job('PublishDemoApp') {
    //name 'Publish-Python-Demo-App'
    //description 'Python Demo App- Publish'
    label ('swarm')
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
    steps {
        shell(BASE_STEPS)
    }
    publishers {
        archiveJunit('target/*.xml')
    }
}
