# heroku-openresty-buildpack 

## Introduction

This is customized version of
[geoffleyland/heroku-buildpack-openresty](https://github.com/geoffleyland/heroku-buildpack-openresty)
buildpack, that gives ability to use [OpenResty](http://openresty.org)
as proxy in front of deployed application.

OpenResty comes with builtin lua support.

## Installation & usage

Add this buildpack to your heroku application, with:

```
$ heroku buildpack:set https://github.com/flyerbee-com/heroku-buildpack-openresty
```

Then, copy provided `nginx.conf.template` to root of your application
source code and *rename it* to `nginx.conf`. Adjust it to suit your needs.

### Using custom lua packages

In case you'd like to have installed custom lua libraries (or
[lua rocks](https://luarocks.org/)), add `rockspec` file to your
project on the same location where your put `nginx.conf`.

Here is example how to install `lua-resty-http` library:

```lua
package = "PROJECT_NAME"
version = "1-1"

source = {
  url = "",
}

build = {
  type = "builtin",
  modules = {},
}

-- actual dependencies used by openresty
dependencies = {
  "lua-resty-http"
}
```

Update `PROJECT_NAME` to actual name of your project and save file as: `PROJECT_NAME-1-1.rockspec`.

## License

Most of the work has been done by
[https://github.com/geoffleyland](https://github.com/geoffleyland).
