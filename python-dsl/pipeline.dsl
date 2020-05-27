pipelineJob('pipeline') {
    parameters {
        labelParam('swarm')
    }
          definition {
              cpsScm {
                  scriptPath 'Jenkinsfile'
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
              }
          }
      }
