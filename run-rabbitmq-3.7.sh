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
readonly erlang_version='22.3.4.26'
readonly rmq_version='3.7.15'
readonly rmq_nodename="rabbit-3_7_15@localhost"
declare -ri rmq_node_port=5682

source "$script_dir/common.bash"

setup_rabbitmq

start_rabbitmq

wait_input
