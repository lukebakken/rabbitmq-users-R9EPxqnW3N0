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

readonly certs_dir="$script_dir/certs"
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
    "$rmq_ctl" -n "$rmq_nodename" shutdown
    echo '[INFO] exiting!'
}
trap on_exit EXIT

function setup_rabbitmq
{
    if [[ ! -s $rmq_xz ]]
    then
        curl -LO "https://github.com/rabbitmq/rabbitmq-server/releases/download/v$rmq_version/rabbitmq-server-generic-unix-$rmq_version.tar.xz"
    fi

    if [[ ! -d $rmq_dir ]]
    then
        tar xf "$rmq_xz"
    fi

    # Generate RabbitMQ conf file
    sed -e "s|##CERTS_DIR##|$certs_dir|" "$script_dir/rabbitmq-$rmq_version.conf.in" > "$rmq_etc_dir/rabbitmq.conf"
}

function start_rabbitmq
{
    # Start RabbitMQ and wait
    RABBITMQ_NODENAME="$rmq_nodename" RABBITMQ_NODE_PORT="$rmq_node_port" "$rmq_server" -detached
    sleep 5
    "$rmq_ctl" -n "$rmq_nodename" await_startup

    readonly rmq_plugins="$rmq_sbin_dir/rabbitmq-plugins"
    if [[ -x $rmq_plugins ]]
    then
        "$rmq_plugins" -n "$rmq_nodename" enable rabbitmq_management rabbitmq_top rabbitmq_shovel rabbitmq_shovel_management
    else
        echo "[ERROR] expected to find '$rmq_plugins', exiting" 1>&2
        exit 69
    fi
}

function wait_input
{
    echo '[INFO] enter any key to exit RabbitMQ'
    read _unused
    unset _unused
}
