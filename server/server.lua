QBCore = exports['qb-core']:GetCoreObject()

-------------
--Variables--
-------------

local removedSigns = {}

----------
--Events--
----------

RegisterNetEvent('signrobbery:server:RemoveSign', function(signInfo, signObject, signCoords, signHash)
	if exports.ox_inventory:CanCarryItem(source, signInfo.Item, 1) then
        exports.ox_inventory:AddItem(source, signInfo.Item, 1)
		TriggerClientEvent('signrobbery:client:RemoveSign', -1, signInfo, signCoords)

		removedSigns[signObject] = {
			hash = signHash,
			coords = signCoords,
			model = signInfo.Model,
		}
    else
        lib.notify(source, {
            title = "Attention",
            description = "Inventory is full!",
            type = 'inform'
        })
    end
end)

-------------
--Callbacks--
-------------

lib.callback.register('signrobbery:server:GetRemovedSigns', function()
	return removedSigns
end)

-- lib.addCommand('relog', {
--     help = 'Reload player',
-- }, function(source, args)
-- 	TriggerClientEvent('QBCore:Client:OnPlayerLoaded',    source)
-- end)