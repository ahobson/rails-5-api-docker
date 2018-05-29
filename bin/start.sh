#!/bin/bash

if [ -f tmp/pids/server.pid ]; then
  rm -f tmp/pids/server.pid
fi

bin/rails db:setup
bin/rails s -p $PORT -b 0.0.0.0
