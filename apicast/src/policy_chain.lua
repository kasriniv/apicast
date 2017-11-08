local setmetatable = setmetatable
local insert = table.insert
local error = error
local rawset = rawset
local type = type
local require = require
local noop = function() end

local linked_list = require('linked_list')
local policy = require('policy')

local _M = {

}

local mt = {
    __index = _M,
    __newindex = function(t, k ,v)
        if t.frozen then
            error("readonly table")
        else
            rawset(t, k, v)
        end
    end
}

function _M.build(modules)
    local chain = {}
    local list = modules or { 'apicast' }

    for i=1, #list do
        chain[i] = _M.load(list[i])
    end

    return _M.new(chain)
end

function _M.load(module, ...)
    if type(module) == 'string' then
        ngx.log(ngx.DEBUG, 'loading policy module: ', module)
        return require(module).new(...)
    else
        return module
    end
end

function _M.new(list)
    local chain = list or {}

    local self = setmetatable(chain, mt)
    chain.config = self:export()
    return self:freeze()
end

function _M:freeze()
    self.frozen = true
    return self
end

function _M:add(module)
    insert(self, _M.load(module))
end

function _M:export()
    local chain = self.config

    if chain then return chain end

    for i=#self, 1, -1 do
        local export = self[i].export or noop
        chain = linked_list.readonly(export(self[i]), chain)
    end

    return chain
end

local function call_chain(phase_name)
    return function(self, ...)
        for i=1, #self do
            self[i][phase_name](self[i], ...)
        end
    end
end

for _,phase in policy:phases() do
    _M[phase] = call_chain(phase)
end

return _M.build()
