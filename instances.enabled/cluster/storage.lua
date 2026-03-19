
local vshard = require('vshard')
local crud = require('crud')

dependencies = {
    'tarantool >= 3.1.0',
    'crud >= 1.5.2',
}

box.watch('box.status', function()
    if box.info.ro then
        return
    end


    box.schema.create_space('bands', {
        format = {
            { name = 'id', type = 'unsigned' },
            { name = 'bucket_id', type = 'unsigned' },
            { name = 'band_name', type = 'string' },
            { name = 'year', type = 'unsigned' }
        },
        if_not_exists = true
    })
    box.space.bands:create_index('id', { parts = { 'id' }, if_not_exists = true })
    box.space.bands:create_index('bucket_id', { parts = { 'bucket_id' }, unique = false, if_not_exists = true })
end)
