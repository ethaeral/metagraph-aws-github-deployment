# Project Notes / Draft Documentation
## 09.07.23
Figured out how to pass build into docker compose, trying to figure out how to run the dev smoothely

## 09.01.23
finding how to run dockercompose in a diff dir
list all docker commands in order

docker-compose file created, however BUILD ARG is not being stored for some reason
need to figure it out

next to try is the euclid.json file untouched

## 08.31.23
Created bash script for GITHUB token env
Still struggling with docker and AWS with this configuration

Need to find where hydra composes up

Video also talks about security
https://youtu.be/RqTEHSBrYFw?si=8q6IcSGrsdIgcElt&t=10607

https://www.composerize.com/

scripts/docker.sh -> start_containers
scripts/docker.sh -> create_docker_custom_network
scripts/docker.sh -> run_container
scripts/join-cluster.sh -> join

TODO:
Let hydra accept .env for DEV and PROD
split scripts into dev:local and prod:aws  
## 08.22.23
Goal:   
Spin up a github development to aws production environment for constellation metagraph   

Current pain points:   
Trying to format cloudformation template to reflect what is needed in the euclid dev enironment   
Understanding   

Next steps:   
✔️ From scripts understand in what docker scripts run in what order in infra/docker  
// After understanding the configuration of ea. node and cluster translate it to cloudformation template  
From infra/docker - find a way to just docker context and then docker compose up: 
- https://www.youtube.com/watch?v=Oj3jpxBJOXU
- https://aws.amazon.com/blogs/containers/automated-software-delivery-using-docker-compose-and-amazon-ecs/
- https://aws.amazon.com/blogs/containers/deploy-applications-on-amazon-ecs-using-docker-compose/

Build production scripts   
Build deploy for github actions  
