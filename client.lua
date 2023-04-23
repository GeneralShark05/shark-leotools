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
local visfuncs = { -- For Goggles
    ['nvg'] = {switch = SetNightvision, outfit = {117}},
    ['thm'] = {switch = SetSeethrough, outfit = {119}},
}
local wearingGoggs, activeGoggs = false, false -- Are Goggles Equipped, Are Goggles Active
local goggType = 'nvg' -- Equipped Type

-- Function
local function toggleGoggs()
    local ped = GetPlayerIdentifier()
    if activeGoggs then -- If Goggles are Active, turn them off
        TaskPlayAnim(ped, 'anim@mp_helmets@on_foot', 'goggles_up')
        SetPedComponentVariation(ped, 0, (visfuncs(type).outfit), 0, 0)
    else -- Else, turn them on
        TaskPlayAnim(ped, 'anim@mp_helmets@on_foot', 'goggles_down')
        SetPedComponentVariation(ped, 0, (visfuncs(type).outfit-1), 0, 0)
    end
    Wait(600)
    activeGoggs = not activeGoggs
    visfuncs[goggType].switch(activeGoggs)
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
            TriggerServerEvent('sharkcops:giveBack', goggType)
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
            TriggerServerEvent('sharkcops:giveBack', goggType)
        end
    },
}

--- Events and Exports
exports('sharkcops-vision', function(type)
    local ped = GetPlayerIdentifier()
    if wearingGoggs then -- If already equipped, don't
        lib.notify({
            id = 'goggError',
            title = 'Already Wearing',
            description = 'You alreay have something equipped!',
            type = 'error'
        })
        return false
    else                -- Else, Equip
        TaskPlayAnim(ped, "mp_masks@standard_car@ds@", "put_on_mask", 100, 100, 600, 51)
        Wait(600)

        if type == 'gas' then -- Gas Mask Settings
            lib.addRadialItem(maskRadial)
            SetEntityProofs(ped, false, false, false, false, false, false, true, true, false)
            SetPedComponentVariation(ped, 1, 46, 0, 0)
        elseif type == 'nvg' or type == 'thm' then  -- Goggle Settings
            lib.addRadialItem(goggRadial)
            SetPedComponentVariation(ped, 0, visfuncs(type).outfit, 0, 0)
        else -- Preventing Nil errors
            print('error - '..type)
            return false
        end
 
        wearingGoggs = true
        goggType = type
    end
end)

RegisterNetEvent('sharkcops:removeVision')
AddEventHandler('sharkcops:removeVision', function() -- Remove Goggles
    local ped = GetPlayerIdentifier()
    TaskPlayAnim(ped, "missheist_agency2ahelmet", "take_off_helmet_stand", 100, 100, 1200, 51)
    Wait(1200)
    if goggType == 'gas' then -- Gas Mask Disable
        SetEntityProofs(ped, false, false, false, false, false, false, false, false, false)
        SetPedComponentVariation(ped, 0, 0, 0, 0)
        lib.removeRadialItem(maskRadial)
    else -- Goggle Disable
        visfuncs[type].switch(false)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        lib.removeRadialItem(goggRadial)
    end
    wearingGoggs = false
    goggType = 'nil'
end)