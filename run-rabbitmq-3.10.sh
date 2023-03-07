#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

asdf_home="$HOME/.asdf"
asdf_sh="$asdf_home/asdf.sh"
if [[ -s "$asdf_sh" ]]
then
    # shellcheck source=/dev/null
    source "$asdf_sh"
fi
unset asdf_home
unset asdf_sh

# shellcheck disable=SC2155
readonly script_dir="$(cd "$(dirname "$0")" && pwd)"
readonly erlang_version='25.2.3'
readonly rmq_version='3.10.19'
readonly rmq_nodename="rabbit-3_10_19@localhost"
declare -ri rmq_node_port=5672

source "$script_dir/common.bash"

setup_rabbitmq

start_rabbitmq

wait_input
