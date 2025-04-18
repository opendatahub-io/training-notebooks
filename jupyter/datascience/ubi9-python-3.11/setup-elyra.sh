#!/bin/bash
set -x

# Set the elyra config on the right path
jupyter elyra --generate-config
cp /opt/app-root/bin/utils/jupyter_elyra_config.py /opt/app-root/src/.jupyter/

# create the elyra runtime directory if not present
if [ ! -d $(jupyter --data-dir)/metadata/runtimes/ ]; then
  mkdir -p $(jupyter --data-dir)/metadata/runtimes/
fi
# Set elyra runtime config from volume mount
if [ "$(ls -A /opt/app-root/runtimes/)" ]; then
  cp -r /opt/app-root/runtimes/..data/*.json $(jupyter --data-dir)/metadata/runtimes/
fi

# Set elyra runtime images json from volume mount
if [ "$(ls -A /opt/app-root/pipeline-runtimes/)" ]; then
  cp -r /opt/app-root/pipeline-runtimes/..data/*.json /opt/app-root/share/jupyter/metadata/runtime-images/
fi

# Environment vars set for accessing ssl_sa_certs and sa_token
# export PIPELINES_SSL_SA_CERTS="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
export KF_PIPELINES_SA_TOKEN_ENV="/var/run/secrets/kubernetes.io/serviceaccount/token"
export KF_PIPELINES_SA_TOKEN_PATH="/var/run/secrets/kubernetes.io/serviceaccount/token"
