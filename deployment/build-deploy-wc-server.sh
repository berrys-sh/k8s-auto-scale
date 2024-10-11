#!/bin/bash

./deployment/build-wc-server.sh
./deployment/helm-deploy.sh wc_server_update
