#!/usr/bin/env bash
set -e

if ! luarocks-admin 2>&1 >/dev/null && ! test -e /.dockerenv; then
    docker run --rm -v $PWD:/work -w /work --user=root --rm ubuntu bash /work/$(basename $0) $@
    exit $?
fi

function echoerr() {
  echo $@ 1>&2;
  return 1
}

function usage() {
  echo "Usage: $0 <rock name> <rock version>"
  exit 1
}

if [ $# -ne 2 ]; then
  usage
fi

apt-get update -qq && apt-get install -qq -y lua5.4

luarocks download --all $1 $2

[ ! -f $1-$2*.src.rock ] && echoerr "no src.rock found for $1-$2"
[ ! -f $1-$2*.rockspec ] && echoerr "no rockspec found for $1-$2"

mv $1-$2*.{src.rock,rockspec} rocks/

luarocks-admin make_manifest rocks

