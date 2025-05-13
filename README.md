## KongRocks

This repository serves as Kong Gateway's private Luarocks server.

### How to add a new Rock

The workflow https://github.com/kong/kong_dev_rocks/actions/workflows/add-rock.yaml
automates the addition of new rocks.

- Click "Run workflow" on the right-hand side, enter the rock name and
version, and confirm.
- It is necessary to seek approval on the resulting PR before merging.

### How to remove unused Rock

The workflow https://github.com/kong/kong_dev_rocks/actions/workflows/remove-unused-rock.yaml
automates the removal of unused rocks.

- Click "Run workflow" on the right-hand side and confirm.
- It is necessary to seek approval on the resulting PR before merging.

### Assumptions

* This is to be used in only Kong Gateway (Enterprise) -- 
  https://github.com/Kong/kong-ee/.

* For following Kong Gateway (Enterprise) **private dependencies**, bump the [git submodules](https://github.com/Kong/kong-ee/tree/master/distribution) instead:
  - kong-gql
  - kong-openid-connect
  - lua-resty-openapi3-deserializer
  - lua-resty-openssl-aux-module

* The repository must contain a source rock (`.src.rock`) for all hosted
Lua libraries. This requirement ensures Kong Gateway builds do not need to fetch
sources from an external location, thus contributing to the implementation of the
SLSA framework. (In order to ensure only the sources in here are used, Kong's
build system leverages Luarocks' `--only-sources` flag, additionally to `--only-server`.

* **The repository only hosts libraries that are required by Kong Gateway**. If Kong 
Gateway introduces a new dependency -- or if an existing dependency's version
is bumped -- rockspec and src rock for the library must be imported here.

