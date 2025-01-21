QBCore = exports['qb-core']:GetCoreObject()

-------------
--Variables--
-------------

local holdingSign = false
local cuttingSign = false
local sawIsEquipped = false
local searchingForSign = false
local signObject = nil

----------
--Events--
----------

RegisterNetEvent('signrobbery:client:DisplaySign', function(item)
    if sawIsEquipped then
        lib.notify({
            title = 'Unable',
            description = "How're you going to hold a sign and a blade saw",
            type = 'error'
        })
        return
    end
    
    local player = cache.ped
    local playerCoords = GetEntityCoords(player)

    if not holdingSign then
        local signModel = lib.requestModel(item.client.model, 60000)
        local holdingAnim = lib.requestAnimDict('amb@world_human_janitor@male@base')
        signObject = CreateObject(signModel, playerCoords.x, playerCoords.y, playerCoords.z, true, true, false)
        AttachEntityToEntity(signObject, player, GetPedBoneIndex(player, 57005), 0.10, -1.0, 0.0, -90.0, -250.0, 0.0, true, true, false, false, true, true)
        TaskPlayAnim(player, holdingAnim, "base", 4.0, 1.0, -1, 49, 0, 0, 0, 0)
        SetModelAsNoLongerNeeded(signModel)
        RemoveAnimDict(holdingAnim)
        holdingSign = true
    else
        ClearPedTasks(player)
        DeleteObject(signObject)
        holdingSign = false
        signObject = nil
    end
end)

RegisterNetEvent("signrobbery:client:RemoveSign", function(signInfo, signCoords)
    local sign = GetClosestObjectOfType(signCoords.x, signCoords.y, signCoords.z, 1.2, signInfo.Model, false, false, false)

    if DoesEntityExist(sign) then
        SetEntityAsMissionEntity(sign, true, true)
        DeleteObject(sign)
        SetEntityAsNoLongerNeeded(sign)
    end
end)

RegisterNetEvent('signrobbery:client:EquipBladeSaw', function()
    if holdingSign then
        lib.notify({
            title = 'Unable',
            description = "How're you going to hold a blade saw and a sign",
            type = 'error'
        })
        return
    end

    local player = cache.ped
    local coords = GetEntityCoords(player)

    if not sawIsEquipped then
        sawIsEquipped = true
        searchingForSign = true

        lib.requestModel('prop_tool_consaw', 60000)
        lib.requestAnimDict('weapons@heavy@minigun')

        bladeSaw = CreateObject('prop_tool_consaw', coords,  true,  true, true)
        AttachEntityToEntity(bladeSaw, player, GetPedBoneIndex(player, 36029), -0.3, 0.0, -0.15, 180.0, 180.0, 0.0, true, true, false, true, 1, true)
        SetModelAsNoLongerNeeded(bladeSaw)
        TaskPlayAnim(player, 'weapons@heavy@minigun', "idle_2_aim_right_med", 8.0, 1.0, -1, 50, 0, 0, 0, 0)
        TriggerEvent('signrobbery:client:CheckForNearbySigns')
    else
        ClearPedTasks(player)
        DeleteEntity(bladeSaw)
        sawIsEquipped = false
        searchingForSign = false
        lib.hideTextUI()
    end
end)

RegisterNetEvent('signrobbery:client:CheckForNearbySigns', function()
    local hold = (Config.GenericStuff.SignCutTimeInSeconds * 1000)
    local signObject = nil

    CreateThread(function()
        while sawIsEquipped do
            local playerCoords = GetEntityCoords(cache.ped)

            if signObject == nil then
                signObject = CheckForNearbySign()
            end
            local signCoords = GetEntityCoords(signObject)

            if #(playerCoords - signCoords) > 1.5 then
                signObject = nil
                signCoords = nil
                lib.hideTextUI()
            end

            lib.hideTextUI()

            if signObject ~= nil then
                lib.showTextUI("Hold [E] To cut down sign")

                if hold <= 0 and sawIsEquipped then
                    TriggerEvent('signrobbery:client:CutDownSign', signCoords, signObject)
                    hold = (Config.GenericStuff.SignCutTimeInSeconds * 1000)
                end

                if IsControlPressed(0, 38) then
                    if hold - 100 >= 0 then
                        lib.requestNamedPtfxAsset('core')
                        UseParticleFxAsset('core')
                        StartNetworkedParticleFxNonLoopedAtCoord('ent_brk_sparking_wires_sp', signCoords.x, signCoords.y, signCoords.z + 1, 0.0, 0.0, 0.0, 0.3, 0.0, 0.0, 0.0, 0)

                        hold = hold - 100
                    end
                end

                if IsControlReleased(0, 38) then
                    hold = (Config.GenericStuff.SignCutTimeInSeconds * 1000)

                    if isSoundPlaying then
                        TriggerEvent('signrobbery:client:TriggerCuttingSound')
                        isSoundPlaying = false
                    end
                end
            end
            Wait(100)
        end
    end)
end)

RegisterNetEvent('signrobbery:client:CutDownSign', function(signCoords, signObject)
    local signHash = GetEntityModel(signObject)

    for index, signInfo in pairs(Config.Signs) do
        if signHash == signInfo.Hash then
            TriggerServerEvent('signrobbery:server:RemoveSign', signInfo, signObject, signCoords, signHash)
            return
        end
    end
end)

-------------
--Functions--
-------------

function CheckForNearbySign(playerCoords)
    while searchingForSign do
        local playerCoords = GetEntityCoords(cache.ped)

        for k, v in pairs(Config.Signs) do
            local signObject = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 1.2, v.Model, false, false, false)
            local signHash = GetEntityModel(signObject)

            if signHash == v.Hash then
                return signObject
            end
            Wait(100)
        end
    end
end

----------------------------
--Player Load/Unload Stuff--
----------------------------

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    local removedSigns = lib.callback.await('signrobbery:server:GetRemovedSigns', false)

    Wait(1000)

    if next(removedSigns) == nil then
        return
    end

    for k, v in pairs(removedSigns) do
        local relogSign = GetClosestObjectOfType(v.coords.x, v.coords.y, v.coords.z, 2.0, v.model, false, false, false)

        if DoesEntityExist(relogSign) then
            SetEntityAsMissionEntity(relogSign, true, true)
            DeleteEntity(relogSign)
            SetEntityAsNoLongerNeeded(relogSign)
        end
    end

    lib.notify({
        title = 'Removed',
        description = 'All signs were removed',
        type = 'success'
    })
end)