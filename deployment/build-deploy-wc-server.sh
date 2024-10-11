#!/bin/bash

./build-wc-server.sh
./helm-deploy.sh wc_server_update
