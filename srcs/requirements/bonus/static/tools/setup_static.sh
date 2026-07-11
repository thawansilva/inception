#!/bin/sh

set -e

envsubst '' > /etc/nginx.conf.template
