QBCore = exports['qb-core']:GetCoreObject()


RegisterServerEvent('Lean:server:buySprite')
AddEventHandler('Lean:server:buySprite', function()
  local src = source
	local Player = QBCore.Functions.GetPlayer(src)

    local cash = Player.PlayerData.money.cash
    if cash >= Config.spriteAl then
        Player.Functions.RemoveMoney("cash", Config.spriteAl)
        Wait(500)
        Player.Functions.AddItem('sprite', 1)
        TriggerClientEvent('lj-inventory:client:ItemBox', src, QBCore.Shared.Items['sprite'], "add", 1)

        TriggerClientEvent("QBCore:Notify", src, Config.SpriteBuy, 'success')

    else
                TriggerClientEvent("QBCore:Notify", src, Config.noMoney, 'error')

    end
end)




RegisterServerEvent('Lean:server:buyJelibon')
AddEventHandler('Lean:server:buyJelibon', function()
  local src = source
	local Player = QBCore.Functions.GetPlayer(src)

    local cash = Player.PlayerData.money.cash
    if cash >= Config.jelibonAl then
        Player.Functions.RemoveMoney("cash", Config.jelibonAl)
        Wait(500)
        Player.Functions.AddItem('jelibon', 1)
        TriggerClientEvent('lj-inventory:client:ItemBox', src, QBCore.Shared.Items['jelibon'], "add", 1)

        TriggerClientEvent("QBCore:Notify", src, Config.JelibonBuy, 'success')

    else

        TriggerClientEvent("QBCore:Notify", src, Config.noMoney, 'error')

    end
end)





RegisterServerEvent('Lean:server:buyBuz')
AddEventHandler('Lean:server:buyBuz', function()
  local src = source
	local Player = QBCore.Functions.GetPlayer(src)

    local cash = Player.PlayerData.money.cash
    if cash >= Config.su then
        Player.Functions.RemoveMoney("cash", Config.su)
        Wait(500)
        Player.Functions.AddItem('buz', 1)
        TriggerClientEvent('lj-inventory:client:ItemBox', src, QBCore.Shared.Items['buz'], "add", 1)


        TriggerClientEvent("QBCore:Notify", src, Config.buzBuy, 'success')


    else
        TriggerClientEvent("QBCore:Notify", src, Config.noMoney, 'error')
    end
end)




RegisterServerEvent('Lean:server:buyŞurup')
AddEventHandler('Lean:server:buyŞurup', function()
  local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local cash = Player.PlayerData.money.cash
    if cash >= Config.surup then
        Player.Functions.RemoveMoney("cash", Config.surup)
        Wait(500)
        Player.Functions.AddItem('şurup', 1)
        TriggerClientEvent('lj-inventory:client:ItemBox', src, QBCore.Shared.Items['şurup'], "add", 1)


        TriggerClientEvent("QBCore:Notify", src, Config.SurupBuy, 'success')



    else
        TriggerClientEvent("QBCore:Notify", src, Config.noMoney, 'error')

    end
end)




RegisterServerEvent('Lean:server:buyBardak')
AddEventHandler('Lean:server:buyBardak', function()
  local src = source
	local Player = QBCore.Functions.GetPlayer(src)

    local cash = Player.PlayerData.money.cash
    if cash >= Config.bardak then
        Player.Functions.RemoveMoney("cash", Config.bardak)
        Wait(500)
        Player.Functions.AddItem('bardak', 1)
        TriggerClientEvent('lj-inventory:client:ItemBox', src, QBCore.Shared.Items['bardak'], "add", 1)

        TriggerClientEvent("QBCore:Notify", src, Config.bardakBuy, 'success')

    else
                TriggerClientEvent("QBCore:Notify", src, Config.noMoney, 'error')

    end
end)



QBCore.Functions.CreateUseableItem('lean', function(source)
    local src = source
    TriggerClientEvent('client:useLean', src)
end)

