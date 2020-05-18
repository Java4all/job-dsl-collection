pipelineJob('pipeline') {
          definition {
              cpsScm {
                  scriptPath 'Jenkinsfile'
                  scm {
                    git {
                        remote { 
                            url ('https://gitlab.com/elesvi1/python-flask-jen.git')
                            credentials('jenslave')
                        }
                        branch '*/master'
                        extensions {}
                    }
                  }
              }
          }
      }
