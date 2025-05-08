#!/usr/bin/env bash

set -o pipefail
set -e

versions=""

declare -A rocks

for version in $versions; do
    for rock in $(docker run --rm kong/kong-gateway-dev:$version-ubuntu luarocks list --porcelain| awk '{print $1 "-" $2}' | grep -v kong-plugin-); do
        rocks[$rock]="$version ${rocks[$rock]}"
    done
done


declare -A unused_rocks

for rockfile in rocks/*.rockspec; do
    rock=$(basename $rockfile)
    # split ext
    rock=${rock%.*}
    if [ -z "${rocks[$rock]}" ]; then
        ts=$(git log --pretty='format:%ct' --follow -- $rockfile | { head -n1; cat >/dev/null; })
        unused_rocks[$rock]="$ts"
    fi
done

{
    echo "Used rocks:"
    echo "| Rock | Version |"
    echo "| ---- | ------- |"
    for rock in "${!rocks[@]}"; do
        echo "| $rock | ${rocks[$rock]} |"
    done | sort
} > used_rocks.txt

echo "Used rocks written to used_rocks.txt"

rm -f removed_rocks.txt

{
    echo "Unsed rocks:"
    echo "| Rock | Added  | Removed |"
    echo "| ---- | ------- | ---- |"
    for rock in "${!unused_rocks[@]}"; do
        ts="${unused_rocks[$rock]}"
        echo -n "| $rock | $(date -d @$ts +'%x') |"
        if [ "$(date -d '-14 days' +%s)" -gt "$ts" ]; then
            rm -f rocks/$rock.rockspec rocks/$rock.src.rock
            echo "$rock" >> removed_rocks.txt
            echo "Yes |"
        else
            echo "No |"
        fi
    done | sort
} > unused_rocks.txt

test -s unused_rocks.txt  && echo "Unused rocks written to unused_rocks.txt"
test -s removed_rocks.txt && echo "Removed rocks written to removed_rocks.txt"

cmd="luarocks-admin make_manifest rocks"

if ! luarocks-admin 2>&1 >/dev/null && ! test -e /.dockerenv; then
    docker run --rm -v $PWD:/work -w /work --user=root --rm kong:3.1.0 $cmd
else
    $cmd
fi

