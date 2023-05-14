----------------------------
-- Window Tint Checker --
----------------------------
RegisterNetEvent('shark-leotools:checkTint')
AddEventHandler('shark-leotools:checkTint', function(entityID)
    if entityID ~= nil then
        local tintLev = GetVehicleWindowTint(entityID)
        print(tintLev)
        local tintDesc = ''..Config.tintTable[tintLev]..'% Tint Level'
        lib.notify({
            id = 'tintInfo',
            description = tintDesc,
            type = 'inform'
        })
    else
        lib.notify({
            id = 'tintError',
            description = 'Tint Meter Error',
            type = 'error'
        })
    end
end)

local tintOption = {
    {
        name = 'shark:tint',
        onSelect = function(data) 
            TriggerEvent('shark-leotools:checkTint', data.entity)
        end,
        icon = 'fa-solid fa-magnifying-glass',
        label = 'Check Window Tint',
        items = 'tintmeter',
        bones = {
            'window_lf1',
            'window_lf2',
            'window_lf3',
            'window_rf1',
            'window_rf2',
            'window_rf3',
            'window_lr1',
            'window_lr2',
            'window_lr3',
            'window_rr1',
            'window_rr2',
            'window_rr3',
            'windscreen_f',
            'windscreen',
        }
    }
}

exports.ox_target:addGlobalVehicle(tintOption)

----------------------------
-- NIK Kits --
----------------------------
RegisterNetEvent('shark-leotools:nikkit')
AddEventHandler('shark-leotools:nikkit', function()
    lib.progressBar({
        duration = 2000,
        label = 'Testing..',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
        },
        anim = {
            dict = 'amb@prop_human_parking_meter@male@base',
            clip = 'base'
        },
    })
end)

----------------------------
-- NVGs and Gas Masks --
----------------------------
local wearingGoggs, activeGoggs = false, false -- Are Goggles Equipped, Are Goggles Active
local wearType, clothesType, switchType, itemName

-- Function
local function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
            print('wait '..animDict)
        end
    end
    return animDict
end

local function toggleGoggs()
    local ped = PlayerPedId()
    ensureAnimDict('anim@mp_helmets@on_foot')

    if activeGoggs then -- If Goggles are Active, turn them off -- dict = 'anim@mp_helmets@on_foot', name = 'goggles_up'
        TaskPlayAnim(ped, 'anim@mp_helmets@on_foot', 'goggles_up', 8.0, -8.0, -1, 48, 0, false, false, false)
        Wait(600)
        SetPedPropIndex(ped, 0, clothesType, 0, 0)
    else -- Else, turn them on -- dict = 'anim@mp_helmets@on_foot', name = 'goggles_down'
        TaskPlayAnim(ped, 'anim@mp_helmets@on_foot', 'goggles_down', 8.0, -8.0, -1, 48, 0, false, false, false)
        Wait(600)
        SetPedPropIndex(ped, 0, (clothesType - 1), 0, 0)
    end

    RemoveAnimDict('anim@mp_helmets@on_foot')
    activeGoggs = not activeGoggs
    switchType(activeGoggs)
end

-- Radials
local goggRadial = {
    {
        label = 'Toggle Goggles',
        id = 'shark-leotools:toggle',
        icon = 'power-off',
        onSelect = function()
            toggleGoggs()
        end
    },
    {
        label = 'Remove Goggles',
        id = 'shark-leotools:remove',
        icon = 'eye-slash',
        onSelect = function()
            TriggerEvent('shark-leotools:removeVision')
        end
    },
}

local maskRadial = {
    {
        label = 'Remove Mask',
        id = 'shark-leotools:remove',
        icon = 'mask-ventilator',
        onSelect = function()
            TriggerEvent('shark-leotools:removeVision')
        end
    },
}

--- Events and Exports
exports('vision', function(data, slot)
    local ped = PlayerPedId()

    itemName = data.name
    wearType = Config.Goggles[data.name].type
    clothesType = Config.Goggles[data.name].clothes
    switchType = Config.Goggles[data.name].switch

    if wearingGoggs then -- If already equipped, don't
        lib.notify({
            id = 'goggError',
            title = 'Already Wearing',
            description = 'You already have something equipped!',
            type = 'error'
        })
        return false
    else 
        exports.ox_inventory:useItem(data, function(data)
            ensureAnimDict('mp_masks@on_foot')
            TaskPlayAnim(ped, "mp_masks@on_foot", "put_on_mask", 8.0, -8.0, -1, 48, 0, false, false, false)
            Wait(600)
            
            if wearType == 'gas' then -- Gas Mask Settings
                lib.addRadialItem(maskRadial)
                SetEntityProofs(ped, false, false, false, false, false, false, true, true, false)
                SetPedComponentVariation(ped, 1, clothesType, 0, 0)
            elseif wearType == 'nvg' or wearType == 'thm' then  -- Goggle Settings
                lib.addRadialItem(goggRadial)
                SetPedPropIndex(ped, 0, clothesType, 0, 0)
            end

            RemoveAnimDict('mp_masks@on_foot')
            wearingGoggs = true
        end)
    end
end)

RegisterNetEvent('shark-leotools:removeVision')
AddEventHandler('shark-leotools:removeVision', function() -- Remove Goggles
    local ped = PlayerPedId()
    ensureAnimDict('missheist_agency2ahelmet')
    TaskPlayAnim(ped, "missheist_agency2ahelmet", "take_off_helmet_stand", 8.0, -8.0, -1, 48, 0, false, false, false)
    Wait(1000)
    
    if wearType == 'gas' then -- Gas Mask Disable
        SetEntityProofs(ped, false, false, false, false, false, false, false, false, false)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        lib.removeRadialItem('shark-leotools:remove')
    else -- Goggle Disable
        switchType(false)
        ClearPedProp(ped, 0)
        lib.removeRadialItem('shark-leotools:toggle')
        lib.removeRadialItem('shark-leotools:remove')
    end
    TriggerServerEvent('shark-leotools:giveBack', itemName)
    RemoveAnimDict('missheist_agency2ahelmet')
    wearingGoggs = false
end)