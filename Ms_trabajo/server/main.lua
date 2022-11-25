ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('comienzo:envio')
AddEventHandler('comienzo:envio', function()
  local user = ESX.GetPlayerFromId(source)
  user.addInventoryItem('heroin', 10)
end)

RegisterServerEvent('entrega:mercancia')
AddEventHandler('entrega:mercancia', function()
  local user = ESX.GetPlayerFromId(source)
  user.removeInventoryItem('heroin', 10)
  user.addInventoryItem('coke', 10)
end)

RegisterServerEvent('entrega:envio')
AddEventHandler('entrega:envio', function()
  local user = ESX.GetPlayerFromId(source)
  user.removeInventoryItem('coke', 10)
  user.addMoney(1000000)
end)
