#!/usr/bin/env tarantool

local crud = require('crud')
local vshard = require('vshard')

local log = require('log')
local fiber = require('fiber')

dependencies = {
    'tarantool >= 3.1.0',
    'crud >= 1.5.2',
}

-- Функция инициализации router
local function init_router()

    log.info('init_router')
    
    for i = 1, 20 do
        local oki, info = pcall(vshard.router.info)
        if oki and info then
            log.info('vshard initialized, status: %s', info.status)
            if info.status == 0 then
                break
            else
                local ok, result = pcall(vshard.router.bootstrap)
                if not ok then
                    log.error('VShard bootstrap failed: %s', result)
                else
                    log.info('VShard bootstrap result: %s', result)
                    break
                end
            end
        else
            log.info('waiting vshard initialize')
        end
        fiber.sleep(1)  -- Ждём 1 сек
    end
    log.info('VShard bootstrapped successfully')
    return true
end

-- Основная логика запуска
log.info('Starting router.lua')
local instance_name = os.getenv('TT_INSTANCE_NAME')
log.info('Starting instance: %s', instance_name)

if string.find(instance_name, 'router') then
    init_router()
end