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
source code and *rename it* to `nginx.conf`; adjust it to suit your
needs.

By default, OpenResty expects your application to listen on port
`8080`. In case you have other port in mind, update `nginx.conf`
`proxy_pass` variable.

## Updating Procfile

Make sure to update your `Procfile`. In general, the content should
be:

```
web: openresty.sh <command-to-start-your-application>
```

For example, to start custom Java application, `Procfile` will look
like:

```
web: openresty.sh java $JVM_OPTS -jar app.jar
```

## Updating your application

When your application is ready to serve requests sent by OpenResty,
make sure to create empty `/tmp/app-initialized` file. This is a
checkpoint for `heroku-buildpack-openresty` startup scripts, after
which OpenResty will be started.

In case your application doesn't create this file, it will be assumed
it wasn't initialzed properly and OpenResty startup will fail.

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
[https://github.com/geoffleyland](https://github.com/geoffleyland). Further
customizations by Sanel Zukan for FLYERBEE AG.
