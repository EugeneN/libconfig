# TODO pass AppState explicitly
_AppState = window.AppState

{pubsubhub} = require 'libprotein'
{pub, sub} = pubsubhub()

get_data = (store, [k, tail...]) ->
    return undefined unless store

    if tail.length
        get_data store[k], tail
    else
        store[k]


set_data = (store, [k, tail...], data) ->
    return undefined unless k
    
    if tail.length
        store[k] or= {}
        store[k] = set_data store[k], tail, data
        store
    else
        store[k] = data
        store

get_config = (key, {config}=_AppState) -> get_data config, (key.split '.')
set_config = (key, value, {config}=_AppState) -> 
    set_data config, (key.split '.'), value
    pub key, (get_config key)

get = get_config
set = set_config

on_config_changed = (key, handler, {config}=_AppState) ->
    sub key, handler


module.exports = {get_config, set_config, on_config_changed, get, set}
