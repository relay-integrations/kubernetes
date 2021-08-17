#!/bin/sh
set -eou pipefail

NS=$(ni get -p {.namespace})
CLUSTER=$(ni get -p {.cluster.name})
KUBECONFIG=/workspace/${CLUSTER}/kubeconfig

ni cluster config

declare -a KUBECTL_ARGS

ARGS=$(ni get -p {.args})
COMMAND=$(ni get -p {.command})
FILE=$(ni get -p {.file})

FILE_PATH=${FILE}

GIT=$(ni get -p {.git})
if [ -n "${GIT}" ]; then
    ni git clone
    NAME=$(ni get -p {.git.name})
    FILE_PATH=/workspace/"${NAME}"/${FILE}
fi

if [ -n "${FILE}" ]; then
    KUBECTL_ARGS+=( -f ${FILE_PATH} )
fi

KUBECTL_ARGS+=( $ARGS )

if [ -n "${NS}" ]; then
    KUBECTL_ARGS+=( --namespace ${NS} )
fi

if [ -n "${CLUSTER}" ]; then
    KUBECTL_ARGS+=( --kubeconfig ${KUBECONFIG} )
fi

echo "Running command: kubectl ${COMMAND} ${KUBECTL_ARGS[@]}"
kubectl ${COMMAND} ${KUBECTL_ARGS[@]}
