#! /bin/bash

rails assets:precompile && rails db:migrate && rspec