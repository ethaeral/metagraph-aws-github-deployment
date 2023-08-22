<!-- 

[``](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/) 

-->

[Constellation](https://docs.constellationnetwork.io/sdk/guides/quick-start/) Documentation Quick start guide   

Start of scripts:

[`scripts/hydra install`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/hydra#L21)
- 🏃🏽 Run `loads_scripts` which gathers all functions from
    - [`./docker.sh`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh)
    - [`./join-cluster.sh`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/join-cluster.sh)
    - [`./custom-template.sh`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/custom-template.sh)
    - [`./utils.sh`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/utils.sh)
- 📞 Calls 
    - [`fill_env_variables_from_json_config_file`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/utils.sh#L27)
        - 📞 Calls 
            - [`check_if_package_is_installed`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/utils.sh#L13) 
            - [`check_if_config_file_is_the_new_format`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/utils.sh#L20) 
        - Creates environment variables from euclid.json with jq an command line JSON processor
    - [`check_if_project_name_is_set`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/custom-template.sh#L37) 
        - **LAST** -> COPIES TEMPLATE VERSIONS FROM TESSLEATION 
    - [`create_template`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/custom-template.sh#L3) 


[`scripts/hydra build`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/765f8f21ec8f5870169bc53d305eb9db4e5b17da/.references/euclid-development-environment/scripts/hydra#L49)

[`scripts/hydra start_genesis`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/hydra#L209)

[`scripts/hydra stop`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/hydra#L252)

[`scripts/hydra destroy`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/hydra#L293)
