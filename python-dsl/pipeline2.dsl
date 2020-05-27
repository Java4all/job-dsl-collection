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
        shell("""echo Hello World!
        export KUBECONFIG=$KUBECONG
        kubectl get pods"""
        )
    }
    publishers {
        archiveJunit('target/*.xml')
    }
}
