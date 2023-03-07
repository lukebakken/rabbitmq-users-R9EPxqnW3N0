#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

asdf_home="$HOME/.asdf"
asdf_sh="$asdf_home/asdf.sh"
if [[ -s "$asdf_sh" ]]
then
    source "$asdf_sh"
fi
unset asdf_home
unset asdf_sh

# shellcheck disable=SC2155
readonly script_dir="$(cd "$(dirname "$0")" && pwd)"
readonly erlang_version='22.3.4.26'
readonly rmq_version='3.7.15'

source "$script_dir/common.bash"

setup_rabbitmq

start_rabbitmq

wait_input
