
function Load(name)
	local resourceName = GetCurrentResourceName()
	local chunk = LoadResourceFile(resourceName, ('data/%s.lua'):format(name))
	if chunk then
		local err
		chunk, err = load(chunk, ('@@%s/data/%s.lua'):format(resourceName, name), 't')
		if err then
			error(('\n^1 %s'):format(err), 0)
		end
		return chunk()
	end
end

-------------------------------------------------------------------------------
-- Settings
-------------------------------------------------------------------------------

Config = {}

-- It's possible to interact with entities through walls so this should be low
Config.MaxDistance = 1.6

-- Enable debug options
Config.Debug = false

-- Supported values: true, false
Config.Standalone = false

-- Enable outlines around the entity you're looking at
Config.EnableOutline = false

-- Enable default options (Toggling vehicle doors)
Config.EnableDefaultOptions = false

-- Disable the target eye whilst being in a vehicle
Config.DisableInVehicle = false

-- Key to open the target
Config.OpenKey = 'LMENU' -- Left Alt
Config.OpenControlKey = 19 -- Control for keypress detection also Left Alt for the eye itself, controls are found here https://docs.fivem.net/docs/game-references/controls/

-- Key to open the menu
Config.MenuControlKey = 237 -- Control for keypress detection on the context menu, this is the Right Mouse Button, controls are found here https://docs.fivem.net/docs/game-references/controls/

-------------------------------------------------------------------------------
-- Target Configs
-------------------------------------------------------------------------------

-- These are all empty for you to fill in, refer to the .md files for help in filling these in

Config.CircleZones = {

}

Config.BoxZones = {
	["pddashcam"] = {
        name = "PD Dashcam",
        coords = vector3(442.31, -999.67, 34.97), 
        length = 1.0,
        width = 3.4,
        heading = 359,
        debugPoly = false,
        minZ= 34.77,
        maxZ= 35.37,
        options = {
            {
                type = "client",
                event = "rp_interact:client:PoliceDashCams", 
                icon = "fas fa-circle",
                label = "Araç Kameralarını Görüntüle",
                job = "police",
            },
        },
        distance = 1.5
    },
}

Config.PolyZones = {

}

Config.TargetBones = {
}

Config.TargetEntities = {
    
}

Config.TargetModels = {
}

Config.GlobalPedOptions = {
}

Config.GlobalVehicleOptions = {
	options = {
		{
			event = "polisaracislemleri",
			icon = "fas fa-wrench",
			label = "Polis Araç İşlemleri",
			job = 'police'
		},
		{
			event = "qb-trunk:client:GetIn",
			icon = "fas fa-truck-loading",
			label = "Bagaja Gir"
		},
		{
            label = 'Kelepçeliyi Araca Bindir/İndir',
            icon = 'fas fa-user',
			type = 'command',
            event = 'araç'
		},
		{
            label = 'Yaralıyı Araca Bindir/İndir',
            icon = 'fas fa-user',
			type = 'command',
            event = 'ybindir'
		},
	},
}

Config.GlobalObjectOptions = {
}

Config.GlobalPlayerOptions = {
	options = {
		{
			type = "client",
			event = "qb-phone:client:GiveContactDetails",
			icon = "fas fa-address-book",
			label = "Numaranı Ver",
		},
		{
			type = "command",
			event = "kucakla",
			icon = "fas fa-people-carry",
			label = "Kucakla",
		},
		{
			type = "command",
			event = "taşı",
			icon = "fas fa-people-carry",
			label = "Yaralıyı Taşı",
		},
		{
			type = "client",
			event = "police:client:RobPlayer",
			icon = "fas fa-gun",
			label = "Soy",
		},
		{
			type = "client",
			event = "polisislemleri",
			icon = "fas fa-users",
			label = "Polis İşlemleri",
			job = "police",
		},
		{
			type = "client",
			event = "doktorislemleri",
			icon = "fas fa-ambulance",
			label = "Doktor İşlemleri",
			job = "ambulance",
		},
	},
}

--
Config.Peds = {
    {
        model = `mp_m_securoguard_01`,
        coords = vector4(-76.05, -817.87, 325.18, 260.38),
        networked = true,
        invincible = true,
        blockevents = true,
		freeze = true,
        target = {
            options = {
                {
                    type = "client",
                    event = "torpak",
                    icon = "fas fa-sign-in-alt",
                    label = "Sign In",
                },
            },
            distance = 2.5
        }
    }
}

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------
local function JobCheck() return true end
local function GangCheck() return true end
local function ItemCount() return true end
local function CitizenCheck() return true end

CreateThread(function()
	if not Config.Standalone then
		local QBCore = exports['qb-core']:GetCoreObject()
		local PlayerData = QBCore.Functions.GetPlayerData()

		ItemCount = function(item)
			for _, v in pairs(PlayerData.items) do
				if v.name == item then
					return true
				end
			end
			return false
		end

		JobCheck = function(job)
			if type(job) == 'table' then
				job = job[PlayerData.job.name]
				if job and PlayerData.job.grade.level >= job then
					return true
				end
			elseif job == 'all' or job == PlayerData.job.name then
				return true
			end
			return false
		end

		GangCheck = function(gang)
			if type(gang) == 'table' then
				gang = gang[PlayerData.gang.name]
				if gang and PlayerData.gang.grade.level >= gang then
					return true
				end
			elseif gang == 'all' or gang == PlayerData.gang.name then
				return true
			end
			return false
		end

		CitizenCheck = function(citizenid)
			return citizenid == PlayerData.citizenid or citizenid[PlayerData.citizenid]
		end

		RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
			PlayerData = QBCore.Functions.GetPlayerData()
			SpawnPeds()
		end)

		RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
			PlayerData = {}
			DeletePeds()
		end)

		RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
			PlayerData.job = JobInfo
		end)

		RegisterNetEvent('QBCore:Client:OnGangUpdate', function(GangInfo)
			PlayerData.gang = GangInfo
		end)

		RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
			PlayerData = val
		end)
	else
		local firstSpawn = false
		AddEventHandler('playerSpawned', function()
			if not firstSpawn then
				SpawnPeds()
				firstSpawn = true
			end
		end)
	end
end)

function CheckOptions(data, entity, distance)
	if distance and data.distance and distance > data.distance then return false end
	if data.job and not JobCheck(data.job) then return false end
	if data.gang and not GangCheck(data.gang) then return false end
	if data.item and not ItemCount(data.item) then return false end
	if data.citizenid and not CitizenCheck(data.citizenid) then return false end
	if data.canInteract and not data.canInteract(entity, distance, data) then return false end
	return true
end