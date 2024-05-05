#! /bin/bash

docker build -t pandemiccms_rspec -f ./cmd/rspec/Dockerfile .
docker run -it --rm --network host pandemiccms_rspec