# {{header1}}
# {{header2}}

{% set types = {
    'Long': {'real': 'long'},
    'Float': {'real': 'float'}, 
    'Double': {'real': 'double'},
    'Byte': {'real': 'unsigned char'}
}
%}

from PyTorch cimport *

cdef extern from "LuaHelper.h":
    void *getGlobal(lua_State *L, const char *name1, const char *name2);
    void require(lua_State *L, const char *name)
    int getLuaRegistryIndex()

{% for Real in types %}
{% if Real in ['Double', 'Float'] %}
cdef extern from "LuaHelper.h":
    TH{{Real}}Tensor *pop{{Real}}Tensor(lua_State *L)
    void push{{Real}}Tensor(lua_State *L, TH{{Real}}Tensor *tensor)
{% endif %}
{% endfor %}

cdef extern from "lua_externc.h":
    struct lua_State
    void lua_pushnumber(lua_State *L, float number)
    float lua_tonumber(lua_State *L, int index)
    void lua_pushstring(lua_State *L, const char *value)
    const char *lua_tostring(lua_State *L, int index)
    void lua_call(lua_State *L, int argsIn, int argsOut)
    void lua_remove(lua_State *L, int index)
    void lua_insert(lua_State *L, int index)
    void lua_getglobal(lua_State *L, const char *name)
    void lua_setglobal(lua_State *L, const char *name)
    void lua_settable(lua_State *L, int index)
    void lua_gettable(lua_State *L, int index)
    void lua_getfield(lua_State *L, int index, const char *name)
    void lua_pushnil(lua_State *L)
    void lua_pushvalue(lua_State *L, int index)
    int lua_next(lua_State *L, int index)
    int lua_gettop(lua_State *L)
    int lua_isuserdata(lua_State *L, int index)

cdef class LuaState(object):
    cdef lua_State *L

cdef LuaState_fromNative(lua_State *L)
