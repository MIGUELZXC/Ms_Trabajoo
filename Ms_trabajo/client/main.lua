local punto = vector3(162.56, -1924.52, 21.19)
local spawn = vec4(166.76, -1930.36, 21.00, 229.60)
local modeloDeVehiculo = 'Youga'
local envios = {
    vector3(186.05, -1676.91, 29.49),
    vector3(210.43, -2034.68, 18.17),
    vector3(399.82, -1875.46, 26.02),
    vector3(243.07, -1700.32, 28.90),
    vector3(16.04, -1882.70, 22.94)
}
ESX = exports['es_extended']:getSharedObject()


CreateThread(function()
    local job = false
    local job2 = false
    SpawnNPC('g_m_y_salvaboss_01', vector4(162.56, -1924.52, 20.19, 229.60))
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        if #(playerCoords - punto) < 4 then
            if job == true or job2 == true then
                Create3D(vector3(162.56, -1924.52, 22.19), '~r~ve a hacer el envio y traeme la van asi te pago.')
            else
                Create3D(vector3(162.56, -1924.52, 22.19), '[~g~E~s~] para hacer la entrega') 
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent('comienzo:envio')
                    RequestModel(modeloDeVehiculo)
                    while not HasModelLoaded(modeloDeVehiculo) do
                        Wait(0)
                    end
                    local vehiculo = CreateVehicle(GetHashKey(modeloDeVehiculo),spawn, false, false)
                    envio = envios[math.random(1,#envios)]
                    blips = AddBlipForCoord(envio)
                    SetBlipRoute(blips, true)
                    BeginTextCommandSetBlipName('STRING')
                    AddTextComponentSubstringBlipName('ENTREGA')
                    EndTextCommandSetBlipName(blips)
                    job = true
                end
            end
        end
        if job then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            if #(playerCoords - envio) < 6 then
                DrawMarker(1, envio.xy, envio.z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.5, 3.5, 1.5, 0, 255, 255, 100, false, true, 0, false)
                if IsControlJustPressed(0, 38) then
                    FreezeEntityPosition(GetVehiclePedIsIn(playerPed, true))
                    Wait(2000)
                    FreezeEntityPosition(GetVehiclePedIsIn(playerPed, false))
                    ESX.ShowNotification('Ahora devuelve el vehiculo para recibir tu pago', true, false, 140)
                    RemoveBlip(blips)
                    blip = AddBlipForCoord(spawn)
                    SetBlipRoute(blip, true)
                    TriggerServerEvent('entrega:mercancia')
                    job= false
                    job2 = true
                end        
            end
        end
        if job2 then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            if #(playerCoords - spawn.xyz) < 4 then
                DrawMarker(1, spawn.xy, spawn.z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.5, 2.5, 1.5, 0, 255, 255, 100, false, true, 0, false)
                if IsControlJustPressed(0, 38) then
                    DeleteVehicle(GetVehiclePedIsIn(playerPed))
                    ESX.ShowNotification('recibiste tu dinero', true, false, 140)
                    RemoveBlip(blip)
                    TriggerServerEvent('entrega:envio')
                    job = false
                    job2 = false
                end
            end
        end
        Wait(0)
    end
end)

local npcs = {
    {model = 'g_m_y_salvaboss_01', coords = vector4(184.03, -1679.74, 28.66, 323.14)},
     {model = 'g_m_y_salvaboss_01', coords = vector4(397.08, -1873.16, 25.21, 232.44)},
     {model = 'g_m_y_salvaboss_01', coords = vector4(240.19, -1698.48, 28.22, 235.27)},
     {model = 'g_m_y_salvaboss_01', coords = vector4(13.04, -1886.10, 22.23, 320.31)},
     {model = 'g_m_y_salvaboss_01', coords = vector4(214.74, -2032.11, 17.39, 121.88)},
 }
 
 CreateThread(function()
     for i,v in pairs(npcs) do
         SpawnNPC(v.model, v.coords)
     end
     while true do
         local playerPed = PlayerPedId()
         local playerCoords = GetEntityCoords(playerPed)
         for i,v in pairs(npcs) do
             if #(playerCoords - v.coords.xyz) < 5 then
                 Create3D(vec3(v.coords.xy, v.coords.z+2), "entrega la mercancia y largate!!!")
             end
         end
         Wait(0)
     end
 end)

SpawnNPC = function(modelo, x,y,z,h)
    hash = GetHashKey(modelo)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(1)
    end
    crearNPC = CreatePed(5, hash, x,y,z,h, false, true)
    FreezeEntityPosition(crearNPC, true)
    SetEntityInvincible(crearNPC, true)
    SetBlockingOfNonTemporaryEvents(crearNPC, true)
end
Create3D = function(coords, texto)
    local x, y, z = table.unpack(coords)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(5)
        AddTextComponentString(texto)
        DrawText(_x,_y)
    end
end
CreateThread(function()
    local blip = AddBlipForCoord(vec3(162.56, -1924.52, 21.19))

    SetBlipSprite (blip, 226) -- sprite
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 1.3) -- escala
    SetBlipColour (blip, 29) -- color
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Trabajo de encargos")
    EndTextCommandSetBlipName(blip)
end)


