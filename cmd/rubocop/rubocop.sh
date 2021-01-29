#! /bin/bash

docker build -t pandemiccms_rubocop ./cmd/rubocop/
docker run -it --rm -v ${PWD}:/app pandemiccms_rubocop