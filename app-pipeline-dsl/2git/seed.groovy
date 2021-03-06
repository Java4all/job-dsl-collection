def project_name = '2git'
def repo_name = 'Praqma/2git'
def cred_id = "100247a2-70f4-4a4e-a9f6-266d139da9db"

/** Integration **/
def integrationJob = job("$project_name-integrate") {
    defaults(delegate)
    description('pretested integration, \'gradle test\'')

    scm {
        git {
            remote {
                github(repo_name)
                credentials(cred_id)
            }
            branch('*/ready/**')
            extensions {
                cleanBeforeCheckout()
                pruneBranches()
            }
        }
    }

    triggers {
        githubPush()
    }

    wrappers {
        pretestedIntegration('SQUASHED', 'master', 'origin')
    }

    steps {
        gradle("clean test")
    }

    publishers {
        pretestedIntegration()
        buildPipelineTrigger("$project_name-release") {
            parameters {
                gitRevision(true)
            }
        }
    }
}

/** Release **/
def releaseJob = job("$project_name-release") {
    defaults(delegate)
    description('tags commit and archives the uberjar')

    scm {
        git {
            remote {
                github(repo_name)
                credentials(cred_id)
            }
            branch('master')
            extensions {
                wipeOutWorkspace()
            }
        }
    }

    authorization {
        permission('hudson.model.Item.Read', 'anonymous')
    }

    steps {
        environmentVariables {
            propertiesFile('gradle.properties')
        }
        gradle('clean uberjar')
    }

    publishers {
        archiveArtifacts {
            pattern('build/libs/*.jar')
            onlyIfSuccessful()
        }
        git {
            pushOnlyIfSuccess()
            tag('origin', '${VERSION}') {
                create()
            }
        }
    }
}

/** UTILS **/
def defaults(def job) {
    job.with {
        logRotator(-1, 10)

        wrappers {
            buildName('#${BUILD_NUMBER}-${GIT_REVISION,length=5}')
            timestamps()
            timeout {
                noActivity(360)
            }
        }
    }
}
