local ox_inventory = exports.ox_inventory

--------- NIK Kit
local testKit = ox_inventory:registerHook('swapItems', function(payload)
    local src = payload.source
    local testresult = 'Negative'

    if  payload.toSlot ~= nil and payload.toSlot.name ~= 'nikkit' and payload.fromInventory == payload.source then
        local drug = payload.toSlot.name
        TriggerClientEvent('ox_inventory:closeInventory', src)
        TriggerClientEvent('shark-nikkit-TestKit', src)
        Wait(2000)
        ox_inventory:RemoveItem(src, 'nikkit', 1)
        for key, value in pairs(Config.NIK) do
            for k, v in ipairs(Config.NIK[key]) do
                if v == drug then
                    testresult = key..' Positive'
                break end
            end
        end
        ox_inventory:AddItem(src, 'usednikkit', 1, {description = testresult})
        return false
    end
end,
{
    print = true,
    itemFilter = {nikkit = true}
})

---- NVGs
RegisterServerEvent('sharkcops:giveBack', function(type)
    ox_inventory:AddItem(source, type, 1)
end)