#!/bin/bash

set -euo pipefail

readonly erlang_version='22.3.4.26'
readonly rabbitmq_version='3.7.15'
readonly rabbitmq_xz="rabbitmq-server-${rabbitmq_version}.tar.xz"
if [[ ! -s $rabbitmq_xz ]]
then
    curl -LO "https://github.com/rabbitmq/rabbitmq-server/releases/download/v${rabbitmq_version}/${rabbitmq_xz}"
fi
