#!/usr/bin/env bash

function check_if_tessellation_needs_to_be_rebuild() {
    PROJECT_TESSELLATION_VERSION=$(sed -n 's/.*val tessellation = "\(.*\)".*/\1/p' ../source/project/$PROJECT_NAME/project/Dependencies.scala)
    echo_white "Project tessellation version: $PROJECT_TESSELLATION_VERSION"
    echo_white "Tessellation version provided on euclid.json: $TESSELLATION_VERSION"
    if [[ "$PROJECT_TESSELLATION_VERSION" != "$TESSELLATION_VERSION" ]]; then
        echo_red "Your custom project contains a different version of tessellation than provided on euclid.json, please rebuild tessellation on build with the instruction hydra build --rebuild_tessellation"
        exit 1
    fi
}

function check_if_package_is_installed() {
    if [[ -z "$(which $1 | grep "/")" ]]; then
        echo_red "Could not find package $1, please install this package first"
        exit 1;
    fi
}

function check_if_config_file_is_the_new_format() {
    if [[ ! -f "euclid.json" ]]; then
        echo_red "In version 0.4.0, Euclid environment variables were migrated to a JSON format in euclid.json. You will need to manually migrate your variables in .env to euclid.json"
        exit 1
    fi
}

function fill_env_variables_from_json_config_file() {
    check_if_package_is_installed jq
    check_if_config_file_is_the_new_format
    
    export METAGRAPH_ID=$(jq -r .metagraph_id euclid.json)
    export TESSELLATION_VERSION=$(jq -r .tessellation_version euclid.json)
    export TEMPLATE_VERSION=$(jq -r .framework.version euclid.json)
    export TEMPLATE_VERSION_IS_TAG_OR_BRANCH=$(jq -r .framework.ref_type euclid.json)
    export PROJECT_NAME=$(jq -r .project_name euclid.json)
    export FRAMEWORK_NAME=$(jq -r .framework.name euclid.json)
    export FRAMEWORK_MODULES=$(jq -r .framework.modules euclid.json)
    export P12_GENESIS_FILE_NAME=$(jq -r .p12_files.genesis.file_name euclid.json)
    export P12_GENESIS_FILE_KEY_ALIAS=$(jq -r .p12_files.genesis.alias euclid.json)
    export P12_GENESIS_FILE_PASSWORD=$(jq -r .p12_files.genesis.password euclid.json)
    export P12_NODE_2_FILE_NAME=$(jq -r .p12_files.validators[0].file_name euclid.json)
    export P12_NODE_2_FILE_KEY_ALIAS=$(jq -r .p12_files.validators[0].alias euclid.json)
    export P12_NODE_2_FILE_PASSWORD=$(jq -r .p12_files.validators[0].password euclid.json)
    export P12_NODE_3_FILE_NAME=$(jq -r .p12_files.validators[1].file_name euclid.json)
    export P12_NODE_3_FILE_KEY_ALIAS=$(jq -r .p12_files.validators[1].alias euclid.json)
    export P12_NODE_3_FILE_PASSWORD=$(jq -r .p12_files.validators[1].password euclid.json)
    export DOCKER_CONTAINERS=$(jq -r .docker.default_containers euclid.json)
    
    ## Colors
    export OUTPUT_RED=$(tput setaf 1)
    export OUTPUT_GREEN=$(tput setaf 2)
    export OUTPUT_YELLOW=$(tput setaf 3)
    export OUTPUT_CYAN=$(tput setaf 6)
    export OUTPUT_WHITE=$(tput setaf 7)

    fill_github_token_from_env
}

# CUSTOM: Read from ENV so GITHUB_TOKEN doesn't need to be hard written
function fill_github_token_from_env(){
    if [[ ${GITHUB_TOKEN:-"unset"} == "unset" ]]; then
        if [ -f .env ]; then
            set -o allexport
            source .env
            set +o allexport
            if [[ ${GITHUB_TOKEN:-"unset"} == "unset" ]]; then
                echo_red "No GITHUB_TOKEN in .env"
                exit 1
            else
                echo_white "Enviroment Variables Set"
            fi
        else
            echo_red "No GITHUB_TOKEN found make .env or set server variables"
            exit 1
        fi
    else 
        echo_white "Enviroment Variables Set"
        check_if_github_token_is_valid
    fi
}

function check_if_github_token_is_valid() {
    if curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user | grep -q "Bad credentials"; then
        echo_red "Invalid GITHUB_TOKEN"
        exit 1
    fi
}

function checkout_tessellation_version() {
    cd $2/
    echo_white "Checking version $1"
    if [ ! -z "$(git ls-remote origin $1)" ]; then
        git pull &>/dev/null
        git checkout $1 &>/dev/null
        echo_green "Valid version"
        cd ../
    else
        echo_red "Invalid version"
        exit 1
    fi
}

function get_metagraph_id_from_metagraph_l0_genesis() {
    for ((i = 1; i <= 11; i++)); do
        METAGRAPH_ID=$(docker logs metagraph-l0-1 -n 1000 2>&1 | grep -o "Address from genesis data is .*" | grep -o "DAG.*")
        if [[ -z "$METAGRAPH_ID" ]]; then
            if [ $i -eq 10 ]; then
                echo_red "Could not find the metagraph_id, check the Metagraph L0 Genesis node logs"
                exit 1
            fi
            echo_white "metagraph_id not found trying again in 30s"
            sleep 30
        else
            cd ../../../
            echo_url "METAGRAPH_ID: " $METAGRAPH_ID
            echo_white "Filling the euclid.json file"
            contents="$(jq --arg METAGRAPH_ID "$METAGRAPH_ID" '.metagraph_id = $METAGRAPH_ID' euclid.json)" && \
            echo -E "${contents}" > euclid.json
            
            fill_env_variables_from_json_config_file
            
            cd infra/docker/metagraph-l0-genesis
            break
        fi
    done
}

function check_p12_files() {
    echo_white "All 3 P12 files should be inserted on source/p12-files directory"
    if [ ! -f "../source/p12-files/$P12_GENESIS_FILE_NAME" ]; then
        echo_red "File does not exists"
        exit 1
    fi
    
    if [ ! -f "../source/p12-files/$P12_NODE_2_FILE_NAME" ]; then
        echo_red "File does not exists"
        exit 1
    fi
    
    if [ ! -f "../source/p12-files/$P12_NODE_3_FILE_NAME" ]; then
        echo_red "File does not exists"
        exit 1
    fi
}

function echo_green() {
    echo $OUTPUT_GREEN$1
}

function echo_yellow() {
    echo $OUTPUT_YELLOW$1
}

function echo_white() {
    echo $OUTPUT_WHITE$1
}

function echo_red() {
    echo $OUTPUT_RED$1
}

function echo_title() {
    echo $OUTPUT_CYAN"############ $1 ############"
}

function echo_url(){
    echo $OUTPUT_YELLOW$1 $OUTPUT_WHITE$2
}