#!/bin/bash
set -e

echo "Starting integration test..."

#network=$(docker network ls --format "{{.Name}}")
ci_network=ci_network_${CI_COMMIT_REF_SLUG}
project_name=micro_service_a_${CI_COMMIT_REF_SLUG}

# Clear the previous env.
docker network rm $ci_network
docker-compose -f docker-compose-integration-test.yml -p $project_name ps
docker-compose -f docker-compose-integration-test.yml -p $project_name down

# Create the new env.
docker network create -d nat $ci_network
docker-compose -f docker-compose-integration-test.yml -p $project_name up -d --remove-orphans --force-recreate
docker-compose -f docker-compose-integration-test.yml -p $project_name up ps

# The logs.
docker-compose -f docker-compose-integration-test.yml -p $project_name logs -f integration-test

# Clear the current env.
docker-compose -f docker-compose-integration-test.yml -p $project_name up down
docker network rm $ci_network
