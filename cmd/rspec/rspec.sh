#! /bin/bash

docker build -t pandemiccms_rspec -f ./cmd/rspec/Dockerfile .
docker run -it --rm --network host -e RAILS_MASTER_KEY=${RAILS_MASTER_KEY} pandemiccms_rspec