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

readonly certs_dir="$script_dir/certs"

readonly erlang_version='22.3.4.26'
readonly rmq_version='3.7.15'
readonly rmq_xz="$script_dir/rabbitmq-server-generic-unix-$rmq_version.tar.xz"
readonly rmq_dir="$script_dir/rabbitmq_server-$rmq_version"
readonly rmq_etc_dir="$rmq_dir/etc/rabbitmq"
readonly rmq_sbin_dir="$rmq_dir/sbin"
readonly rmq_server="$rmq_sbin_dir/rabbitmq-server"
readonly rmq_ctl="$rmq_sbin_dir/rabbitmqctl"

asdf shell erlang "$erlang_version" && asdf current

function on_exit
{
    set +o errexit
    echo '[INFO] stopping RabbitMQ...'
    "$rmq_ctl" shutdown
    echo '[INFO] exiting!'
}
trap on_exit EXIT

if [[ ! -s $rmq_xz ]]
then
    curl -LO "https://github.com/rabbitmq/rabbitmq-server/releases/download/v$rmq_version/rabbitmq-server-generic-unix-$rmq_version.tar.xz"
fi

if [[ ! -d $rmq_dir ]]
then
    tar xf "$rmq_xz"
fi

readonly rmq_plugins="$rmq_sbin_dir/rabbitmq-plugins"
if [[ -x $rmq_plugins ]]
then
    "$rmq_plugins" enable rabbitmq_management rabbitmq_top rabbitmq_shovel rabbitmq_shovel_management
else
    echo "[ERROR] expected to find '$rmq_plugins', exiting" 1>&2
    exit 69
fi

# Generate RabbitMQ conf file
sed -e "s|##CERTS_DIR##|$certs_dir|" "$script_dir/rabbitmq.conf.in" > "$rmq_etc_dir/rabbitmq.conf"

# Start RabbitMQ and wait
"$rmq_server" -detached
sleep 5
"$rmq_ctl" await_startup

echo '[INFO] enter any key to exit RabbitMQ'
read _unused
unset _unused
