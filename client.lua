----------------------------
-- NIK Kits --
----------------------------
RegisterNetEvent('sharkcops-nikkit')
AddEventHandler('sharkcops-nikkit', function()
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
local wearType, clothesType, switchType

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
        id = 'sharkcops:toggle',
        icon = 'power-off',
        onSelect = function()
            toggleGoggs()
        end
    },
    {
        label = 'Remove Goggles',
        id = 'sharkcops:remove',
        icon = 'eye-slash',
        onSelect = function()
            TriggerEvent('sharkcops:removeVision')
            TriggerServerEvent('sharkcops:giveBack', wearType)
        end
    },
}

local maskRadial = {
    {
        label = 'Remove Mask',
        id = 'sharkcops:remove',
        icon = 'mask-ventilator',
        onSelect = function()
            TriggerEvent('sharkcops:removeVision')
            TriggerServerEvent('sharkcops:giveBack', wearType)
        end
    },
}

--- Events and Exports
exports('vision', function(data, slot)
    local ped = PlayerPedId()

    wearType = Config.goggConv[data.name]
    clothesType = Config.Goggles[wearType].clothes
    switchType = Config.Goggles[wearType].switch

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

RegisterNetEvent('sharkcops:removeVision')
AddEventHandler('sharkcops:removeVision', function() -- Remove Goggles
    local ped = PlayerPedId()

    TaskPlayAnim(ped, "missheist_agency2ahelmet", "take_off_helmet_stand", 8.0, -8.0, -1, 48, 0, false, false, false)
    Wait(1000)
    
    if wearType == 'gas' then -- Gas Mask Disable
        SetEntityProofs(ped, false, false, false, false, false, false, false, false, false)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        lib.removeRadialItem('sharkcops:remove')
    else -- Goggle Disable
        switchType(false)
        ClearPedProp(ped, 0)
        lib.removeRadialItem('sharkcops:toggle')
        lib.removeRadialItem('sharkcops:remove')
    end

    wearingGoggs = false
end)