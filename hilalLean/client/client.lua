local QBCore = exports['qb-core']:GetCoreObject()

  RegisterNetEvent("torpak", function(source, args, raw)
    exports['qb-menu']:openMenu({
        {
            header = "Lean Yapma ",
            isMenuHeader = true, -- Set to true to make a nonclickable title
        },
        {
            header = "Sprite",
            txt = "Sprite Satın Al",
            params = {
                    event = "Lean:client:spriteAl",
                    icon = "fas fa-coke",-- Burada simge (icon) sınıf adını belirtmelisiniz.

            }
        },
        {
            header = "Jelibon",
            txt = "Jelibon Satın Al",
            disabled = false,
            -- hidden = true, -- doesnt create this at all if set to true
            params = {
                    event = "Lean:client:jelibonAl"
              
            }
        },
        {
          header = "Buz",
          txt = "Buz Satın Al",
          disabled = false,
          -- hidden = true, -- doesnt create this at all if set to true
              params = {
                event = "Lean:client:buzAl"
              }
      },
      {
        header = "Şurup",
        txt = "Calpol Satın al",
        disabled = false,
        -- hidden = true, -- doesnt create this at all if set to true
            params = {
                event = "Lean:client:şurupAl"
            }

    },
    {
        header = "Bardak",
        txt = "Bardak Satın al",
        disabled = false,
        -- hidden = true, -- doesnt create this at all if set to true
            params = {
                event = "Lean:client:bardakAl"
            }

    },
    })
end)
RegisterNetEvent("Lean:client:spriteAl", function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    TriggerServerEvent("Lean:server:buySprite", src)
end)

RegisterNetEvent("Lean:client:jelibonAl", function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    TriggerServerEvent("Lean:server:buyJelibon", src)
end)


RegisterNetEvent("Lean:client:buzAl", function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    TriggerServerEvent("Lean:server:buyBuz", src)
end)


RegisterNetEvent("Lean:client:şurupAl", function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    TriggerServerEvent("Lean:server:buyŞurup", src)
end)


RegisterNetEvent("Lean:client:bardakAl", function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    TriggerServerEvent("Lean:server:buyBardak", src)
end)









RegisterNetEvent('client:useLean', function()
    local prop_name = 'ng_proc_sodacan_01b'
    local ped = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(ped))
    local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
    local boneIndex = GetPedBoneIndex(ped, 4000)
    
    TriggerServerEvent('lean:remove')
    
    TriggerEvent('animations:client:EmoteCommandStart', {"drink"})
    
    QBCore.Functions.Progressbar("example", Config.drinking, 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mp_player_inteat@burger",
        anim = "mp_player_int_eat_burger",
        flags = 49,
    }, {
        AttachEntityToEntity(prop, ped, boneIndex, 0.015, 0.0100, 0.0250, 0.024, -100.0, 40.0, true, true, false, true, 1, true)
    }, {}, function() -- Done
        ClearPedSecondaryTask(ped)
        DeleteObject(prop)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ApplyLeanEffect()
    end)
end)
function ApplyLeanEffect()
    TrevorEffect()
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
    local startStamina = 8
    local interval = 10 -- in seconds
    local timer = GetGameTimer() + interval * 1000
    Citizen.CreateThread(function()
        while startStamina > 0 do
            Wait(0)
            if GetGameTimer() > timer then
                startStamina = startStamina - 1
                timer = GetGameTimer() + interval * 1000
                TrevorEffect()
            end
        end
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
        QBCore.Functions.Notify(Config.LeanS, 'errror')
        TriggerServerEvent('remove:lean')
    end)
end

function TrevorEffect()
    StartScreenEffect("DrugsTrevorClownsFightIn", 3.0, 0)
    Wait(10000)
    StartScreenEffect("DrugsTrevorClownsFight", 3.0, 0)
    Wait(10000)
    StartScreenEffect("DrugsTrevorClownsFightOut", 3.0, 0)
    StopScreenEffect("DrugsTrevorClownsFight")
    StopScreenEffect("DrugsTrevorClownsFightIn")
    StopScreenEffect("DrugsTrevorClownsFightOut")
end