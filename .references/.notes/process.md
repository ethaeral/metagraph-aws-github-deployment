<!-- 

[``](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/) 

-->
# Hydra CLI Process Breakdown 

#### How infrastructure is set up in Euclid Dev in [Constellation](https://docs.constellationnetwork.io/sdk/guides/quick-start/) Documentation Quick start guide   
---


[`scripts/hydra install`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/hydra#L21)
- 📞 Calls [`loads_scripts`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/hydra#L3) which gathers all functions from
    - [`./docker.sh`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh)
    - [`./join-cluster.sh`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/join-cluster.sh)
    - [`./custom-template.sh`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/custom-template.sh)
    - [`./utils.sh`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/utils.sh)
- 📞 Calls 
    - [`fill_env_variables_from_json_config_file`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/utils.sh#L27)
    - ✔️ Checks
        - [`check_if_package_is_installed`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/utils.sh#L13) 
        - [`check_if_config_file_is_the_new_format`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/utils.sh#L20) 
        - 🧱 Sets environment variables from euclid.json with jq an command line JSON processor
        - [`check_if_project_name_is_set`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/custom-template.sh#L37) 
    - [`create_template`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/custom-template.sh#L3) 
    - 🖨 giter copies currency templates from constellations currency

[`scripts/hydra build`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/765f8f21ec8f5870169bc53d305eb9db4e5b17da/.references/euclid-development-environment/scripts/hydra#L49)
- 📞 Calls [`loads_scripts`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/hydra#L3) which gathers all functions from other bash functions
    - 📞 Calls [`set_docker_compose`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh#L3) 
        - ✔️ Checks
            - Checks if docker path and version exists
            -  Checks if docker-compose exists
        - 🧱 Set `dockercompose` variable
- ✔️ Checks
    - [`check_if_docker_is_running`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh#L25)
    - Checks if `GITHUB_TOKEN` is provided
    - [`check_if_github_token_is_valid`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/utils.sh#L58)
    - [`check_p12_files`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/utils.sh#L104)
    - [`check_if_project_name_is_set`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/custom-template.sh#L37)
    - [`check_if_project_directory_exists`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/custom-template.sh#L44)
- 📞 Calls [`create_docker_custom_network`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh#L32)
    - 🏃🏽‍♀️ Runs 
        - if `! docker network inspect custom-network &>/dev/null`
            -     docker network create --driver=bridge --subnet=172.50.0.0/24 custom-network    
- ✔️ Checks
    - [`check_if_tessellation_needs_to_be_rebuild`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/utils.sh#L3)
- 🧱 Set `TESSELLATION_VERSION` & `DOCKER_CONTAINERS` variable
- In the order of `ubuntu-with-java-and-sbt`, `global-l0`, `dag-l1`, `metagraph-l0`, `metagraph-l1-currency`,  `metagraph-l1-data`, `monitoring`
    -  🔧 Builds `${image}` image in `infra/docker/${image}`
        - ✔️ Checks
            - If docker image of ubuntu with java and sbt does not exists and tesselation doesn't need to be rebuild
        - 🧱 Some sets variables like `SHOULD_RESET_GENESIS_FILE`, `FORCE_ROLLBACK`, `METAGRAPH_ID`
        - 🏃🏽‍♀️ Runs 
            -     dockercompose build --build-arg GIT_PERSONAL_ACCESS_TOKEN=$GITHUB_TOKEN --build-arg TESSELLATION_VERSION=$TESSELLATION_VERSION --no-cache 
                -  or without `--no-cache`
- 📞 Calls [`start_containers`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh#L111)
    - ✔️ Checks 
        - [`check_if_images_are_built`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh#L83)
    - 🧱 Set docker container urls variables
    - 📞 Calls [`create_docker_custom_network`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh#L32)
        - 🏃🏽‍♀️ Runs 
            -     docker network create --driver=bridge --subnet=172.50.0.0/24 custom-network
    - 🔧 Builds each container
        - `global-l0`
            - 📞 Calls [`run_container`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh#L41) `global-l0 http://localhost:9000/metrics "GLOBAL-L0"`
                - 👟 Step into dir 
                - 🏃🏽‍♀️ Runs
                    -     dockercompose up -d --no-recreate
                - ⏳ Waits until image is started
            - 🧱 Set url variable
        - `dag-l1`
            - 📞 Calls 
                - [`run_container`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh#L41) `dag-l1 http://localhost:9100/metrics "DAG-L1"`
                - [`join_dag_l1_nodes`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/join-cluster.sh#L3)
                    - 🏃🏽‍♀️ Runs
                        -     docker exec -it dag-l1-2 bash -c "cd genesis/ && \
                                                            export CL_KEYSTORE=\${CL_KEYSTORE_GENESIS} && \
                                                            export CL_KEYALIAS=\${CL_KEYALIAS_GENESIS} && \
                                                            export CL_PASSWORD=\${CL_PASSWORD_GENESIS} && \
                                                            export GENESIS_ID=\$(java -jar cl-wallet.jar show-id) && \
                                                            curl -v -X POST http://localhost:9002/cluster/join -H \"Content-type: application/json\" -d '{ \"id\":\"'\${GENESIS_ID}'\", \"ip\": \"172.50.0.10\", \"p2pPort\": 9001 }' &> /dev/null"
                        -     docker exec -it dag-l1-3 bash -c "cd genesis/ && \
                                                 export CL_KEYSTORE=\${CL_KEYSTORE_GENESIS} && \
                                                 export CL_KEYALIAS=\${CL_KEYALIAS_GENESIS} && \
                                                 export CL_PASSWORD=\${CL_PASSWORD_GENESIS} && \
                                                 export GENESIS_ID=\$(java -jar cl-wallet.jar show-id) && \
                                                 curl -v -X POST http://localhost:9002/cluster/join -H \"Content-type: application/json\" -d '{ \"id\":\"'\${GENESIS_ID}'\", \"ip\": \"172.50.0.10\", \"p2pPort\": 9001 }' &> /dev/null"
            - 🧱 Set url variable
        - `metagraph-l0`
            - 📞 Calls 
                - [`run_container`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh#L41) `metagraph-l0-genesis http://localhost:9400/metrics "METAGRAPH-L0-GENESIS"`
                - [`get_metagraph_id_from_metagraph_l0_genesis`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/utils.sh#L79)
                    - 🧱 Set `METAGRAPH_ID` from `docker logs metagraph-l0-1 -n 1000 2>&1 | grep -o "Address from genesis data is .*" | grep -o "DAG.*"`
                    - ✍🏾 Writes `METAGRAPH_ID` to `euclid.json` 
                    - 📞 Calls [`fill_env_variables_from_json_config_file`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/utils.sh#L27)
                - [`run_container`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh#L41) `metagraph-l0 http://localhost:9500/metrics "METAGRAPH-L0-VALIDATORS"`
                - [`join_metagraph_l0_nodes`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/join-cluster.sh#L34)
                    -     docker exec -it metagraph-l0-2 bash -c "cd genesis/ && \
                                                 export CL_KEYSTORE=\${CL_KEYSTORE_GENESIS} && \
                                                 export CL_KEYALIAS=\${CL_KEYALIAS_GENESIS} && \
                                                 export CL_PASSWORD=\${CL_PASSWORD_GENESIS} && \
                                                 export GENESIS_ID=\$(java -jar cl-wallet.jar show-id) && \
                                                 curl -v -X POST http://localhost:9002/cluster/join -H \"Content-type: application/json\" -d '{ \"id\":\"'\${GENESIS_ID}'\", \"ip\": \"172.50.0.20\", \"p2pPort\": 9001 }' &> /dev/null"
                    -     docker exec -it metagraph-l0-3 bash -c "cd genesis/ && \
                                                       export CL_KEYSTORE=\${CL_KEYSTORE_GENESIS} && \
                                                       export CL_KEYALIAS=\${CL_KEYALIAS_GENESIS} && \
                                                       export CL_PASSWORD=\${CL_PASSWORD_GENESIS} && \
                                                       export GENESIS_ID=\$(java -jar cl-wallet.jar show-id) && \
                                                       curl -v -X POST http://localhost:9002/cluster/join -H \"Content-type: application/json\" -d '{ \"id\":\"'\${GENESIS_ID}'\", \"ip\": \"172.50.0.20\", \"p2pPort\": 9001 }' &> /dev/null"
            - 🧱 Set url variable
        - `metagraph-l1-currency`
            - 📞 Calls 
                - [`run_container`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh#L41) `metagraph-l1-currency "" "METAGRAPH-L1-CURRENCY"`
                - [`join_metagraph_l1_currency_nodes`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/join-cluster.sh#L65)
                    -     docker exec -it metagraph-l1-currency-2 bash -c "cd genesis/ && \
                                                 export CL_KEYSTORE=\${CL_KEYSTORE_GENESIS} && \
                                                 export CL_KEYALIAS=\${CL_KEYALIAS_GENESIS} && \
                                                 export CL_PASSWORD=\${CL_PASSWORD_GENESIS} && \
                                                 export GENESIS_ID=\$(java -jar cl-wallet.jar show-id) && \
                                                 curl -v -X POST http://localhost:9002/cluster/join -H \"Content-type: application/json\" -d '{ \"id\":\"'\${GENESIS_ID}'\", \"ip\": \"172.50.0.30\", \"p2pPort\": 9001 }' &> /dev/null"
                    -     docker exec -it metagraph-l1-currency-3 bash -c "cd genesis/ && \
                                                 export CL_KEYSTORE=\${CL_KEYSTORE_GENESIS} && \
                                                 export CL_KEYALIAS=\${CL_KEYALIAS_GENESIS} && \
                                                 export CL_PASSWORD=\${CL_PASSWORD_GENESIS} && \
                                                 export GENESIS_ID=\$(java -jar cl-wallet.jar show-id) && \
                                                 curl -v -X POST http://localhost:9002/cluster/join -H \"Content-type: application/json\" -d '{ \"id\":\"'\${GENESIS_ID}'\", \"ip\": \"172.50.0.30\", \"p2pPort\": 9001 }' &> /dev/null"
            - 🧱 Set url variable
        - `metagraph-l1-data`
            - 📞 Calls 
                - [`run_container`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh#L41) `metagraph-l1-currency "" "METAGRAPH-L1-CURRENCY"`
                - [`join_metagraph_l1_data_nodes`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/join-cluster.sh#L96)
                    -     docker exec -it metagraph-l1-data-2 bash -c "cd genesis/ && \
                                                 export CL_KEYSTORE=\${CL_KEYSTORE_GENESIS} && \
                                                 export CL_KEYALIAS=\${CL_KEYALIAS_GENESIS} && \
                                                 export CL_PASSWORD=\${CL_PASSWORD_GENESIS} && \
                                                 export GENESIS_ID=\$(java -jar cl-wallet.jar show-id) && \
                                                 curl -v -X POST http://localhost:9002/cluster/join -H \"Content-type: application/json\" -d '{ \"id\":\"'\${GENESIS_ID}'\", \"ip\": \"172.50.0.40\", \"p2pPort\": 9001 }' &> /dev/null"
                    -     docker exec -it metagraph-l1-data-3 bash -c "cd genesis/ && \
                                                 export CL_KEYSTORE=\${CL_KEYSTORE_GENESIS} && \
                                                 export CL_KEYALIAS=\${CL_KEYALIAS_GENESIS} && \
                                                 export CL_PASSWORD=\${CL_PASSWORD_GENESIS} && \
                                                 export GENESIS_ID=\$(java -jar cl-wallet.jar show-id) && \
                                                 curl -v -X POST http://localhost:9002/cluster/join -H \"Content-type: application/json\" -d '{ \"id\":\"'\${GENESIS_ID}'\", \"ip\": \"172.50.0.40\", \"p2pPort\": 9001 }' &> /dev/null"
            - 🧱 Set url variable
        - `monitoring`
            - 📞 Calls [`run_container`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh#L41) `monitoring "" "MONITORING"`
            - 🧱 Set url variable
- 🏃🏽‍♀️ Runs `docker image prune -f`


[`scripts/hydra start_genesis`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/hydra#L209)
- 📞 Calls 
    - [`loads_scripts`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/hydra#L3)
    - [`set_docker_compose`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh#L3)
- ✔️ Checks 
    - [`check_if_docker_is_running`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh#L24)
- 🧱 Set `SHOULD_RESET_GENESIS_FILE` and `FORCE_ROLLBACK`
- 📞 Calls [`start_containers`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh#L111)

[`scripts/hydra stop`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/hydra#L252)
- 📞 Calls 
    - [`loads_scripts`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/hydra#L3)
- 🧱 Set `SHOULD_RESET_GENESIS_FILE`, `FORCE_ROLLBACK`, `METAGRAPH_ID`
- ✔️ Checks 
    - [`check_if_docker_is_running`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/docker.sh#L24)
- In this order checks if image in is in the docker containers if so will run
    -       stop_container metagraph-l1-data "METAGRAPH-L1-DATA" 
            stop_container metagraph-l1-currency "METAGRAPH-L1-CURRENCY"
            stop_container metagraph-l0-genesis "METAGRAPH-L0-GENESIS"
            stop_container metagraph-l0 "METAGRAP-L0-VALIDATORS"
            stop_container dag-l1 "DAG-L1"
            stop_container global-l0 "GLOBAL-L0"
            stop_container monitoring "MONITORING"

[`scripts/hydra destroy`](https://github.com/ethaeral/metagraph-aws-github-deployment/blob/main/.references/euclid-development-environment/scripts/hydra#L293)
