export STACK=heroku-16
TOOLS=$HOME/tools

PATH=$TOOLS/bin:$PATH
export LD_LIBRARY_PATH=$TOOLS/lib
export LUA_PATH="./lua/?.lua;$TOOLS/share/lua/5.1/?.lua"
export LUA_CPATH="./lua/?.so;$TOOLS/lib/lua/5.1/?.so"
